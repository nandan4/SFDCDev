/**
  * @author       : candidate@408970advdev.org
  * @date         : 01/01/2014
  * @description  : Javascript Method to refresh the licenses for a user on page load.
					If a User has a Contractor Id & Refresh Date is empty, an action function "refresh" is invoked
					which in-turn makes a service call to Handyman site to fetch the licenses for the user.
  */ 
function refreshLicenses(){
	alert('** contractorId ==>'+contractorId);
	alert('** refreshDate ==>'+refreshDate);
	// call refresh method if user has contractor id and refresh date is empty 
	if((contractorId != null && contractorId != '') && (refreshDate == null || refreshDate == '')){
		refresh();
	}
}