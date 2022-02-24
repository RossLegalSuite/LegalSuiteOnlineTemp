async mergeDocument( options ) {

    return new Promise((resolve, reject) => { 

        try {

            let response = await axios.post('/word/merge',options);

            //console.log('Downloading',options.destinationFileName);

            if ( response.data.error ) {

                //showError('Template Error',response.data.error);
                reject('Template Error',response.data.error);

            } else {

                if ( options.download ) {

                    // Download the merged document
                    return fetch(response.data.savedFile, {
                        method: 'GET',
                    })

                    .then((resp) => {
                        return resp.blob();
                    })

                    .then((blob) => {
                        
                        download(blob, options.destinationFileName, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');

                    });
                }

                resolve();

            }

        } catch(error) {

            const errorMessage = error.response.data.message.replace(" (this will throw an Error in a future version of PHP)", ""); 

            //showError('Template Error','<p>An error was encountered trying to assemble <em>' + options.sourceFileName + '</em>.</p><p>' + errorMessage + '</p>');
            reject('Template Error','<p>An error was encountered trying to assemble <em>' + options.sourceFileName + '</em>.</p><p>' + errorMessage + '</p>');

        };
    });

},
