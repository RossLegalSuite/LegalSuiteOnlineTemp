<?php

namespace App\Http\Controllers\App;

use App\Custom\Utils;
use App\Mail\EmailMessage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;
use PhpImap\Mailbox;
use PhpMimeMailParser\Parser;

class EmailController extends Controller
{
        /*
            https://github.com/php-mime-mail-parser/php-mime-mail-parser

            To Install on Windows:
            1)  Download Thread Safe version of the Mailparse PHP extension
                from https://pecl.php.net/package/mailparse
            2)  Put it in the ext directory of PHP
            3)  Add this to the php.ini
                extension=php_mailparse.dll; Must be after mbstring as it depends on it
            4)  Restart the server

            To Install on Ubuntu, Debian & derivatives (see the php-mime-mail-parser website)
            but you would probably use something like this: sudo apt install php-cli php-mailparse
        */

    public function sendEmail(Request $request)
    {

            //https://laravel-news.com/allowing-users-to-send-email-with-their-own-smtp-settings-in-laravel

        $returnData = new \stdClass();

        try {
            $configuration = [
                'smtp_host'       => $request->smtpServer,
                'smtp_port'       => $request->smtpPort,
                'smtp_username'   => $request->smtpUserName,
                'smtp_password'   => $request->smtpPassword,
                'smtp_encryption' => $request->smtpEncryption,
                'from_email'      => $request->email,
                'from_name'       => $request->name,
            ];

            // $configuration = [
            //     'smtp_host'    => 'smtp.bittex.co.za',
            //     'smtp_port'    => '587',
            //     'smtp_username'  => 'ettorney@bittex.co.za',
            //     'smtp_password'  => 'Bacon1024!!',
            //     'smtp_encryption'  => 'tls',

            //     'from_email'    => 'admin@acme.co.za',
            //     'from_name'    => 'admin',
            // ];

            $mailer = app()->makeWith('user.mailer', $configuration);

            $mailer->send(new EmailMessage($request->to, $request->cc, $request->bcc, $request->subject, $request->body, $request->attachments));
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to send a mail via the Email Server ('.$request->smtpServer.'). Error: '.$e->getMessage();

            return json_encode($returnData);
        } catch (JWTException $exception) {
            $returnData->error = 'An error was encountered sending the email. Error: '.$exception->getMessage();

            return json_encode($returnData);
        }

        if (count(Mail::failures()) > 0) {
            $returnData->error = 'An error was encountered sending the email to ' + implode(' ', Mail::failures());
        }

        return json_encode($returnData);
    }

    private function getConnection($request, $folderFlag = true)
    {
        $folder = $folderFlag ? $request->folder : '';

        $hostname = $this->getHostName($request).$folder;

        //https://github.com/barbushin/php-imap/wiki/Getting-Started
        $mailbox = new Mailbox(
            $hostname,
            $request->userName,
            $request->password
        );
        //__DIR__, // Directory, where attachments will be saved (optional)
        //'UTF-8' // Server encoding (optional)

        //OP_READONLY flag prevent imap_check from flagging new/recent messages as checked
        $mailbox->setConnectionArgs(OP_READONLY);

        return $mailbox;
    }

    private function getHostName($request)
    {

        // To Do!!!!!!
        //Some servers might use self-signed certificates, in which you would include “novalidate-cert”.
        //{localhost:993/imap/ssl/novalidate-cert}

        //return '{' . $request->incomingServer . ':' . $request->incomingPort . '/imap/' . $request->incomingEncryption. '}';
        return '{'.$request->incomingServer.':'.$request->incomingPort.'/imap/'.$request->incomingEncryption.'/novalidate-cert}';
    }

    public function getMessages(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $returnData->emails = [];

            $cachedMailIdsCounter = count($request->mailIds);

            $mailbox = $this->getConnection($request);

            if ($cachedMailIdsCounter === 0) {

                // First time getting a Folder
                // Get ALL the mailId's for the folder

                $mailIds = $mailbox->searchMailbox('ALL');

                if (count($mailIds)) {

                    //Put latest emails at the beginning
                    rsort($mailIds);

                    //logger('1 ALL mailIds',[$mailIds]);

                    $returnData->folderMailIds = $mailIds;

                    // Get a page of emails
                    $pageOfEmails = array_slice($mailIds, 0, $request->pageSize);

                    foreach ($pageOfEmails as $mailId) {
                        $message = $this->getMessageDetails($mailbox, $mailId);

                        array_push($returnData->emails, $message);
                    }
                } else {
                    $returnData->folderMailIds = [];
                }
            } else {
                $pageOfEmails = array_slice($request->mailIds, $request->currentPage * $request->pageSize, $request->pageSize);

                //$returnData->emails = $mailbox->getMailsInfo($pageOfEmails);

                foreach ($pageOfEmails as $mailId) {
                    $message = $this->getMessageDetails($mailbox, $mailId);

                    array_push($returnData->emails, $message);
                }
            }
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to read email. Error: '.$e->getMessage();

            return json_encode($returnData);
        }

        //$mailbox->disconnect(); // Not sure if this was causing the ERR_CONNECTION_RESET error?

        return json_encode($returnData);
    }

    private function getMessageDetails($mailbox, $mailId)
    {
        $message = new \stdClass();

        $header = $mailbox->getMailHeader($mailId);
        $message->from = isset($header->fromName) ? $header->fromName.' ('.$header->fromAddress.')' : $header->fromAddress;

        $mailInfo = $mailbox->getMailsInfo([$mailId])[0];

        $message->mailId = $mailId;
        $message->date = $mailInfo->date;
        $message->subject = isset($mailInfo->subject) ? $mailInfo->subject : '';
        //$message->from = $mailInfo->from;
        $message->to = $mailInfo->to;
        $message->cc = isset($mailInfo->cc) ? $mailInfo->cc : '';

        $mail = $mailbox->getMail($mailId, false);

        $message->text = $mail->textPlain ? $mail->textPlain : '';

        return $message;
    }

    public function getMessageBody(Request $request)
    {
        $returnData = new \stdClass();
        $returnData->attachments = [];

        $mailbox = $this->getConnection($request);

        try {
            $parser = new Parser();

            $rawText = $mailbox->getRawMail($request->id, false);

            $parser->setText($rawText);

            $htmlEmbedded = $parser->getMessageBody('htmlEmbedded');

            // If email has html body
            if ($htmlEmbedded) {
                $returnData->body = $htmlEmbedded;
            } else {
                $returnData->body = $parser->getMessageBody('text');
            }

            //Get attachments
            $attachments = $parser->getAttachments(false);

            $id = 0;

            foreach ($attachments as $attachment) {
                $attachmentObject = new \stdClass();

                $id++;

                $attachmentObject->id = $id;

                $attachmentObject->fileName = $attachment->getFilename();
                // return logo.jpg

                $attachmentObject->mimeType = $attachment->getContentType();
                // return image/jpeg

                $ext = pathinfo($attachmentObject->fileName, PATHINFO_EXTENSION);

                $knownFileTypes = [
                    'aac',
                    'ai',
                    'avi',
                    'bin',
                    'bmp',
                    'cue',
                    'divx',
                    'doc',
                    'docx',
                    'eps',
                    'flac',
                    'flv',
                    'gif',
                    'html',
                    'ical',
                    'indd',
                    'inx',
                    'iso',
                    'jpg',
                    'mov',
                    'mp3',
                    'mp4',
                    'mpg',
                    'pdf',
                    'php',
                    'png',
                    'pps',
                    'ppt',
                    'psd',
                    'qxd',
                    'qxp',
                    'raw',
                    'rtf',
                    'svg',
                    'tif',
                    'txt',
                    'vcf',
                    'wav',
                    'wma',
                    'xls',
                    'xlxs',
                    'xml',
                ];

                if (in_array($ext, $knownFileTypes)) {
                    $attachmentObject->imageFileName = 'file_'.$ext.'.png';
                } else {
                    $attachmentObject->imageFileName = 'file_unk.png';
                }

                //$attachmentObject->mimeType = $attachment->getMimePartStr();
                // return the whole MIME part of the attachment

                //$attachment->save('/path/to/save/myattachment/', Parser::ATTACHMENT_DUPLICATE_SUFFIX);
                // return the path and the filename saved (same strategy available than saveAttachments)

                array_push($returnData->attachments, $attachmentObject);
            }
        } catch (\Exception $e) {

            //$mailbox->disconnect(); // Not sure if this was causing the ERR_CONNECTION_RESET error?

            $returnData->error = 'An error was encountered trying to retrieve the Email contents. Error: '.$e->getMessage();

            return json_encode($returnData);
        }

        //$mailbox->disconnect(); // Not sure if this was causing the ERR_CONNECTION_RESET error?

        return json_encode($returnData);
    }

    public function uploadEmailMessage(Request $request)
    {
        $returnData = new \stdClass();

        $mailbox = $this->getConnection($request, false);

        $cloudStorage = Storage::disk(session('region'));

        $returnData->path = strtolower(session('companyCode').'/'.session('employeeId').'/email');

        $returnData->url = $cloudStorage->url($returnData->path.'/'.$request->fileName);

        try {
            $rawText = $mailbox->getRawMail($request->id, false);

            $cloudStorage->put($returnData->path.'/'.$request->fileName, $rawText, 'public');

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to save the email file. Error: '.$e->getMessage();

            return json_encode($returnData);
        }
    }

    public function getCorrespondenceEmail(Request $request)
    {
        $returnData = new \stdClass();
        $cloudStorage = Storage::disk(session('region'));

        try {
            $emailFileLocation = $request->path.'/'.$request->fileName;

            $fileExists = $cloudStorage->has($emailFileLocation);

            //logger('$fileExists',[$fileExists]);

            if ($fileExists == true) {
                $emailFile = $cloudStorage->get($emailFileLocation);

                $parser = new Parser();

                $parser->setText($emailFile);

                $returnData->to = $parser->getHeader('to');
                $returnData->from = $parser->getHeader('from');
                $returnData->cc = $parser->getHeader('cc');
                $returnData->subject = $parser->getHeader('subject');

                $htmlEmbedded = $parser->getMessageBody('htmlEmbedded');

                // If email has html body
                if ($htmlEmbedded) {
                    $returnData->body = $htmlEmbedded;
                } else {
                    $returnData->body = $parser->getMessageBody('text');
                }

                $query = DB::table('correspondence_attachments');
                $query->where('correspondenceId', $request->id);
                $returnData->attachments = $query->get()->toArray();
            } else {
                $returnData->error = 'An error was encountered trying to retrieve the Email message: Error: File Not Found ('.$request->url.')';
            }

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to retrieve the Email message. Error: '.$e->getMessage();

            return json_encode($returnData);
        }
    }

    public function saveAttachments(Request $request)
    {
        $returnData = new \stdClass();

        $mailbox = $this->getConnection($request, false);

        try {
            $parser = new Parser();

            $rawText = $mailbox->getRawMail($request->id, false);

            $parser->setText($rawText);

            $path = '/storage/'.strtolower(session('companyCode')).'/'.session('employeeId').'/temp/';

            $savePath = str_replace('\\', '/', public_path().$path);

            $returnData->url = secure_url($path);

            if (! file_exists($savePath)) {
                $makeDirectoryResult = mkdir($savePath, 0777, true);

                if ($makeDirectoryResult === false) {
                    throw new \Exception('Unable to make directory: '.$savePath);
                }
            } else {

                //Delete old temp files

                $files = glob($savePath.'/*'); // get all file names
                foreach ($files as $file) { // iterate files
                    if (is_file($file)) {
                        unlink($file); // delete file
                    }
                }
            }

            $returnData->savedAttachments = $parser->saveAttachments($savePath, false);

            if (count($returnData->savedAttachments) === 0) {
                throw new \Exception('No attachments were saved');
            }

            //logger('returnData->savedAttachments',[$returnData->savedAttachments]);

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to save the email attachments. Error: '.$e->getMessage();

            return json_encode($returnData);
        }
    }

    public function getFolders(Request $request)
    {
        $returnData = new \stdClass();

        $mailbox = $this->getConnection($request, false);

        try {
            $returnData->folders = [];

            $folders = $mailbox->getMailboxes();

            foreach ($folders as $folder) {
                array_push($returnData->folders, $folder['shortpath']);
            }

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to get the Mailbox folders. Error: '.$e->getMessage();

            return json_encode($returnData);
        }

        //$mailbox->disconnect(); // Not sure if this was causing the ERR_CONNECTION_RESET error?

        return json_encode($returnData);
    }

    public function testOutgoingServer(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $configuration = [
                'smtp_host'        => $request->smtpServer,
                'smtp_port'        => $request->smtpPort,
                'smtp_username'    => $request->smtpUserName,
                'smtp_password'    => $request->smtpPassword,
                'smtp_encryption'  => $request->smtpEncryption,
                'from_email'       => $request->email,
                'from_name'        => $request->name,
            ];

            $mailer = app()->makeWith('user.mailer', $configuration);

            $mailer->send(new EmailMessage([$request->email], [], [], 'Test Email from LegalSuite Online', '<p>Dear '.$request->name.'<p><p>This is a test email from LegalSuite Online.<p><p>If you received this message, it means your email setup is working.<p><p>Regards<br><br><br><p><p>LegalSuite Online<p>', []));
        } catch (\Exception $e) {
            $returnData->error = 'An error was encountered trying to access the Email Server ('.$request->smtpServer.'). Error: '.$e->getMessage();

            return json_encode($returnData);
        } catch (JWTException $exception) {
            $returnData->error = "An error was encountered sending a test email to {$request->email}. Error: ".$exception->getMessage();

            return json_encode($returnData);
        }

        return json_encode($returnData);
    }

    public function testIncomingServer(Request $request)
    {
        // Note: To access emails stored in Gmail
        // Go to -> https://myaccount.google.com/security
        // "Less secure app Access" must be on

        $returnData = new \stdClass();

        $mailbox = $this->getConnection($request);

        try {
            $mailbox->checkMailbox();
        } catch (\Exception $e) {

            //$mailbox->disconnect(); // Not sure if this was causing the ERR_CONNECTION_RESET error?

            $returnData->error = 'An error was encountered trying to access the Email Server ('
            .$request->incomingServer.'). Error: '.$e->getMessage();

            return json_encode($returnData);
        }

        return json_encode($returnData);
    }

    //public function getSmtpDetails(Request $request)
    // {

    //     $returnData = new \stdClass();

    //     try {

    //         $apiUrl = "/employee/get/". session('employeeId');

    //         //$postFields['select'] = ['smtpUserName','smtpPassword'];
    //          $postFields = [];

    //          $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

    //          return json_encode($response);

    //         //$returnData->smtpUserName = $response->data->smtpUserName;
    //         //$returnData->smtpPassword = $response->data->smtpPassword;
    //         // $returnData->email = session('employeeEmail');
    //         // $returnData->name = session('employeeName');

    //         //return json_encode($returnData);

    //         /*$apiUrl = "/lolsettings/get";

    //         $lolSettings = Utils::SetCurlParams($apiUrl);

    //         $returnData->smtpServer = $lolSettings->smtpServer;
    //         $returnData->smtpPort = $lolSettings->smtpPort;
    //         $returnData->smtpEncryption = $lolSettings->smtpEncryption;
    //         $returnData->smtpAuthentication = $lolSettings->smtpAuthentication;

    //         $returnData->incomingServer = $lolSettings->incomingServer;
    //         $returnData->incomingPort = $lolSettings->incomingPort;
    //         $returnData->incomingEncryption = $lolSettings->incomingEncryption;*/

    //     } catch(\Exception $e)  {

    //         $returnData['errors'] = $e->getMessage();

    //         return json_encode($returnData);

    //     }

    // }
}
