<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class EmailMessage extends Mailable
{
    use Queueable, SerializesModels;

    public $toAddress;

    public $ccAddress;

    public $bccAddress;

    public $subject;

    public $content;

    public $emailAttachments;

    public function __construct($toAddress, $ccAddress, $bccAddress, $subject, $content, $emailAttachments)
    {
        $this->toAddress = $toAddress;
        $this->ccAddress = $ccAddress;
        $this->bccAddress = $bccAddress;
        $this->subject = $subject;
        $this->content = $content;
        $this->emailAttachments = $emailAttachments;
    }

    public function build()
    {
        $message = $this->view('email.body');

        $message->subject($this->subject);

        $message->from(session('employeeEmail'), session('companyName'));

        $message->replyTo(session('employeeEmail'), session('companyName'));

        $message->to($this->toAddress);

        $message->cc($this->ccAddress);
        $message->bcc($this->bccAddress);

        foreach ($this->emailAttachments as $attachment) {
            $message->attachFromStorageDisk(session('region'), $attachment);
        }

        return $message;
    }
}
