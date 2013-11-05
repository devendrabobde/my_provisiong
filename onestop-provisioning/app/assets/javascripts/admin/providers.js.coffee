# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
 $('#table1').dataTable
   sPaginationType: "bootstrap"
   sDom: "Rlfrtip"
   iDisplayLength: 10
   aaSorting: [[ 0, "asc" ]]
