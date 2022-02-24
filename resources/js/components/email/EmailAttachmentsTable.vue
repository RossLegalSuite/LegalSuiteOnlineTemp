<template>
  <div>
    <div class="d-flex justify-content-between table-functions-row">
      <div></div>
      <div>
        <new-record-button
          type="button"
          title="Add an attachment"
          text="Attachment"
          callback="newAttachment"
          @newAttachment="newAttachment"
        />
      </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%" />

    <div class="modal" :id="id">
      <form class="modal-dialog modal-dialog-centered" @submit="submitForm">
        <div class="modal-content steelblue-border">
          <div class="modal-header steelblue">
            <h4 class="modal-title page-title">{{formTitle}}</h4>

            <i
              title="Close this window"
              class="modal-close-button fa fa-times-circle fa-2x"
              data-dismiss="modal"
            ></i>
          </div>

          <div class="modal-body pb-4">
            <div class="form-group row">
              <div class="col-md-12">
                <b-form-file
                  v-model="file"
                  :state="Boolean(file)"
                  placeholder="Choose a file or drop it here..."
                  drop-placeholder="Drop file here..."
                ></b-form-file>
              </div>
            </div>
          </div>

          <div class="modal-footer justify-content-between">
            <div>
              <!-- <button class="btn btn-large btn-primary" type="button" @click="deleteAttachment">
                <span title="Delete">
                  <i class="fa fa-trash fa-lg mr-2"></i>Delete
                </span>
              </button> -->
            </div>
            <div>
              <button class="btn btn-success form-button mr-3" type="submit" title="Save">
                <i class="fa fa-check-circle fa-lg mr-2"></i>OK
              </button>
              <button
                class="btn btn-danger form-button"
                type="button"
                data-dismiss="modal"
                title="Exit without saving"
              >
                <i class="fa fa-times-circle fa-lg mr-2"></i>Cancel
              </button>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import modalTemplate from "../modals/modal-template";
import tableTemplate from "../tables/table-template";
import { BFormFile } from 'bootstrap-vue';

export default {
  mixins: [modalTemplate, tableTemplate],

  created() {
      
    this.url = null;
    this.title = "Attachments";
    this.plural = "Attachments";
    this.singular = "Attachment";
  },

    components: {
        'b-form-file': BFormFile,
    },

    // Doing this because Vue automatically prefixes directive names with `v-`
    directives: {
        'b-form-file': BFormFile,
    },     
        
    data() {
        
        return {
        errors: {},
        file: null,
        editing: false,
        defaultAttachment: {},
        attachment: {
            id: null,
            description: null,
            url: null
        },
        formTitle: ""
        };
    },

    methods: {

        loadTable() {

          this.destroyTable();

          let _this = this;
          
          //let scrollY = this.setTableHeight(); Doesn't work because it is loaded hidden
          let scrollY = '40vh';

          this.columnDefs = this.createColumnDefs();

          this.table = $("#" + this.tableId).DataTable({
              destroy: true,
              serverSide: false,
              dom: "rt",
              rowId: "id",
              scrollY: scrollY,
              processing: false,

              ordering: true,
              order: [[1, "asc"]],
              select: false,
              scrollX: true,
              scrollCollapse: false,
              scroller: { loadingIndicator: false },

              language: {
                emptyTable: "No Attachments",
                processing: "",
                zeroRecords: "",
                loadingRecords: ""
              },
              data: [],
              columnDefs: this.columnDefs,
              drawCallback: function() {

                    var table = this.api();

                    _this.$parent.$parent.noOfAttachments = table.rows().count();
              }


          });

        },

        defineTableColDefs() {
            
            let tableColumnDefs = [
                {
                  title: "",
                  width: "5%",
                  orderable: false,
                  searchable: false,
                  data: null,
                  targets: 0,
                  render: data => {
                      return (
                      '<i class="fa fa-2x fa-times-circle cp text-danger" title="Remove this Attachment" onclick="componentFunction(\'email-attachments\',\'deleteAttachment\',' +
                      data.id +
                      ')"></i>'
                      );
                  }
                },
                {
                  title: "Attachment",
                  data: null,
                  targets: 1,
                  render: function(data) {
                      return htmlDecode(truncate(data.description));
                  }
                },
                {
                  title: "Document",
                  data: null,
                  targets: 2,
                  render: function(data) {
                      //return htmlAnchor("anchor", data.url, data.fileName);
                      return data.url;
                  }
                },
                // {
                //   title: "fileName",
                //   data: null,
                //   visible: false,
                //   targets: 3,
                //   render: function(data) {
                //       return data.fileName;
                //   }
                // },
                // {
                //   title: "path",
                //   data: null,
                //   visible: false,
                //   targets: 4,
                //   render: function(data) {
                //       return data.path;
                //   }
                // },
            ];

            return tableColumnDefs;
        },

        initFormData() {
            
            this.errors = {};
            this.file = null;
        },

        newAttachment() {

            this.initFormData();

            this.editing = false;

            this.attachment.id = null;

            this.formTitle = "Attachment will be Added";

            $("#" + this.id).modal();
        },

        editRecord(id) {

            this.initFormData();

            this.editing = true;

            let rowData = null;

            rowData = this.table.row("#" + id).data();

            if (typeof rowData === "object") {

                this.attachment.id = id;
                this.attachment.description = rowData.description;
                this.attachment.url = rowData.url;

                this.formTitle = "Attachment will be Changed";

                $("#" + this.id).modal();

            } else {
                showError("System Error","Attachment (" + id + ") not found trying to Edit row");
            }
        },

        addAttachment( description, url) {

          let thisRow = {
              id: Date.now(),
              description: description,
              url: htmlAnchor("anchor", url, getFileName(url)),
              fileName: getFileName(url),
              path: url,
              defaultFlag: false,
          };

          this.table.row.add(thisRow).draw(false);
        },


        addDefaultAttachment() {

          let rowData = this.table.data();

          let defaultAttachmentRow = rowData.filter(row => row.defaultFlag === true);

          if ( defaultAttachmentRow.length) {

            this.table.row('#' + defaultAttachmentRow[0].id).remove().draw();

          }

          let thisRow = {
              id: Date.now(),
              description: this.defaultAttachment.name,
              url: htmlAnchor("anchor", this.defaultAttachment.url, this.defaultAttachment.name),
              // fileName: this.defaultAttachment.name,
              // path: this.defaultAttachment.path,
              fileName: this.defaultAttachment.name,
              path: this.defaultAttachment.url,
              defaultFlag: true,
          };


          this.table.row.add(thisRow).draw(false);

          $("#" + this.tableId + " tbody tr.highlighted").removeClass("highlighted");
          $("#" + this.tableId + " tbody tr#" + thisRow.id).addClass("highlighted");

          this.$parent.$parent.defaultAttachmentUploaded = true;

          this.defaultAttachment = {};

        },

        uploadDefaultAttachment() {

          let rowData = this.table.data();

          let defaultAttachmentRow = rowData.filter(row => row.defaultFlag === true);

          if ( defaultAttachmentRow.length) {

            this.table.row('#' + defaultAttachmentRow[0].id).remove().draw();

          }

          let thisRow = {
              id: Date.now(),
              description: this.defaultAttachment.name,
              url: 'Uploading...Please wait',
              fileName: this.defaultAttachment.name,
              path: '',
              defaultFlag: true,
          };

          this.table.row.add(thisRow).draw(false);

          $("#" + this.tableId + " tbody tr.highlighted").removeClass("highlighted");
          $("#" + this.tableId + " tbody tr#" + thisRow.id).addClass("highlighted");

          this.uploadAttachment(thisRow.id, this.defaultAttachment.file, this.defaultAttachment.name);

          this.defaultAttachment = {};

        },


        uploadAttachment(rowId, fileObj, fileName) {

          var formData = new FormData();

          formData.append("file", fileObj);
          formData.append("fileName", fileName);
          formData.append("folder", 'attachments');

          axios.post('/file/upload', formData, {
              headers: {
                  'Content-Type': 'multipart/form-data'
              }
          })

          .then(response => {

              if (response.data.error) {

                showError('Error uploading attachment',response.data.error);

              } else {

                let rowData = this.table.row('#' + rowId).data();
                  
                if (rowData) {

                    this.$parent.$parent.defaultAttachmentUploaded = true;

                    rowData.url = htmlAnchor("anchor", response.data.url, response.data.fileName);
                    rowData.path = response.data.path;

                    this.table.row('#' + rowId).data( rowData ).draw();

                } else {

                    console.error('Email Attachments Table row (' + rowId + ') not found while trying to update the url for ',fileName);

                }

              }

          });

        },

        submitForm(e) {

          e.preventDefault();
            
          if ( !this.file ) return;

          let thisRow = {
              id: Date.now(),
              description: this.file.name,
              url: 'Uploading...Please wait',
              fileName: this.file.name,
              path: '',
              defaultFlag: false,
          };

          this.table.row.add(thisRow).draw(false);

          $("#" + this.tableId + " tbody tr.highlighted").removeClass("highlighted");
          $("#" + this.tableId + " tbody tr#" + thisRow.id).addClass("highlighted");

          $("#" + this.id).modal("hide");

          this.uploadAttachment(thisRow.id, this.file, this.file.name);


        },



    }
};
</script>
