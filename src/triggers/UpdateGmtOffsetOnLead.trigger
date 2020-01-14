trigger UpdateGmtOffsetOnLead on Lead(after update, after insert) {

	List<Lead> leads = Trigger.new;
	//isExecuting mean that trigger inside web service or exec anon
	//Opportunity view page is a web service
	if (leads.isEmpty() || !Trigger.isExecuting) {
		return;
	}

	UpdateDstOffsetJob subjob = new UpdateDstOffsetJob(leads);
	System.enqueueJob(subjob);
}