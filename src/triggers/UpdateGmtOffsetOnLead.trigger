trigger UpdateGmtOffsetOnLead on Lead(after update, after insert) {

	List<Lead> newLeads = Trigger.new;
	//isExecuting mean that trigger inside web service or exec anon
	if (newLeads.isEmpty() || !Trigger.isExecuting || !TimeUtil.isGeocodesChanged(Trigger.old, Trigger.new)) {
		return;
	}

	UpdateDstOffsetJob subjob = new UpdateDstOffsetJob(newLeads);
	System.enqueueJob(subjob);
}