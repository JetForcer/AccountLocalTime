trigger UpdateDstOffsetOnAccount on Account(after update, after insert) {

	List<Account> accounts = Trigger.new;
	//isExecuting mean that trigger inside web service or exec anon
	//Opportunity view page is a web service
	if (accounts.isEmpty() || !Trigger.isExecuting) {
		return;
	}

	UpdateDstOffsetJob subjob = new UpdateDstOffsetJob(accounts);
	System.enqueueJob(subjob);
}