var getProgressReport = function(dataId){
  $.ajax(
  {
    url: "/admin/providers/pull_redis_job_status.json",
    data: { 'audit_id' : dataId },
    success: function(data){
      var npi_count = data.total_providers
      if (npi_count > 0)
      {
        $("#progress_bar_"+data.sys_audit_trail_id).hide();
        $("#npi_loaded_count_"+data.sys_audit_trail_id).text(data.total_npi_processed + " / " + data.total_providers  );
        $('.auditProgressBar').remove("#progress_bar_"+data.sys_audit_trail_id);
        linkName= $("#audit_link_"+data.sys_audit_trail_id).text();
        dataLink = "<a href='/admin/providers/"+data.sys_audit_trail_id+"'+>"+linkName+"</a>";
        $("#audit_link_"+data.sys_audit_trail_id).html(dataLink);
        return false;
      }
      else if (data.status)
      {
        $("#progress_bar_"+data.sys_audit_trail_id).hide();
        $("#npi_loaded_count_"+data.sys_audit_trail_id).text(data.total_npi_processed + " / " + data.total_providers  );
        $('.auditProgressBar').remove("#progress_bar_"+data.sys_audit_trail_id);
        linkName= $("#audit_link_"+data.sys_audit_trail_id).text();
        dataLink = "<a href='/admin/providers/"+data.sys_audit_trail_id+"'+>"+linkName+"</a>";
        $("#audit_link_"+data.sys_audit_trail_id).html(dataLink);
        return false;
      }
  }, dataType: "json"});
}

$(document).ready(function () {

  $(".waiting_uploaded_file_image").hide();

  $("#upload_csv_file").submit(function(){
   function failValidation(message1)
   {
      $("#dialog").text(message1);
      $("#dialog").dialog();
    return false;
   }
    var extErrorMessage = "Only file with extension .csv is allowed.";
    var emptyErrorMessage = "Plase select a CSV file to initiate the provisioning process.";
    var selectErrorMessage = "Please select application and a CSV file to initiate the provisioning process.";
    var selectApplicationMessage = "Please select application to initiate the provisioning process.";
    file = $("#upload").val();
    if ((file.length == 0) && ($("#provider_registered_app_id").val() == "" ))
    {
      return failValidation(selectErrorMessage);
    }
   else if(file.length == 0 )
   {
     return failValidation(emptyErrorMessage);
   }
   else if(!isCSV(file))
   {
      return failValidation(extErrorMessage);
   }
    else if($("#provider_registered_app_id").val() == "")
    {
      return failValidation(selectApplicationMessage);
    }
  });

  function isCSV(filename) {
    var ext = getExtension(filename);
    switch (ext.toLowerCase()) {
    case 'csv':
      return true;
    }
    return false;
  }

  function getExtension(filename) {
    var parts = filename.split('.');
    return parts[parts.length - 1];
  }

  $("#dialog").hide();
  $('#download_sample_data').hide();
  $("#provider_registered_app_id").change(function() {
      var e = $(this);
      if (e.val() !== ""){
        $('#download_sample_data').find('a').attr('href', "/admin/download_sample_file/"+e.val());
        $('#download_sample_data').show();
      } else{
        $('#download_sample_data').hide();
      }
      $(".application_waiting_image").show();
      $.getJSON(e.attr('data-href'), {
        'registered_app_id': e.val()
        }, function(data) {
        $("#audit_data").html(data.html);
        $(".application_waiting_image").hide();
        $('#table1').dataTable({
          aaSorting: [[0, 'desc']],
          sPaginationType: "bootstrap",
          iDisplayLength: 10,
          aoColumns: [{ "sType": 'num-html' },{ "sType": 'date' },null,null,null,null]
        });
      });
    return false;
  });

  setInterval(function(){
    $('.auditProgressBar').each(function(){
     var id = $(this).data('audit-id');
      remove_audit_id = getProgressReport(id);
    })
  }, 11000 );

  $("#application_registered_app_id").change(function() {
    var e = $(this);
    $(".waiting_uploaded_file_image").show();
    $.getJSON(e.attr('data-href'), {
      'registered_app_id': e.val()
      }, function(data) {
      $(".waiting_uploaded_file_image").hide();
      $("#uploaded_file").html(data.html);
      $('#table1').dataTable({
        aaSorting: [[0, 'desc']],
        sPaginationType: "bootstrap",
        iDisplayLength: 10,
         aoColumns: [{ "sType": 'num-html' },{ "sType": 'date' },null,null,null,null]
      });
    });
    return false;
  });

  $(".fake-uploader").click(function(){
    var e = $(this);
    e.parent().find('.actual-uploader').trigger('click');
  });

  $("#upload").change(function(){
    $("#selected-filename").html($(this).val().replace("C:\\fakepath\\", ""));
  });

  $('#update-password-modal').modal({
    backdrop: 'static',
    keyboard: true
  });

  if ($("#update-password-modal").length != 0){
    $(".alert-success").hide();
  }

  $('#cao_ois_subscribed_Rcopia, #cao_ois_subscribed_EPCS-IDP').change(function(){
    $('#cao_vendor_name').attr('readonly', false);
    $('#cao_vendor_password').attr('readonly', false);
  });

  if($('#cao_ois_subscribed_Rcopia, #cao_ois_subscribed_EPCS-IDP').is(':checked')){
    $('#cao_vendor_name').attr('readonly', false);
    $('#cao_vendor_password').attr('readonly', false);
  }
  
});


//sets up numeric sorting of links
jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "num-html-pre": function ( a ) {
        var x = String(a).replace( /<[\s\S]*?>/g, "" );
        return parseFloat( x );
    },
 
    "num-html-asc": function ( a, b ) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },
 
    "num-html-desc": function ( a, b ) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
} ); 