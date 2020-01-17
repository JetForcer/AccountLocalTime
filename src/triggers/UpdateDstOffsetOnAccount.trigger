trigger UpdateDstOffsetOnAccount on Account(after update, after insert) {

	List<Account> accounts = Trigger.new;
	//isExecuting mean that trigger inside web service or exec anon
	if (accounts.isEmpty() || !Trigger.isExecuting || !TimeUtil.isGeocodesChanged(Trigger.old, Trigger.new)) {
		return;
	}

	UpdateDstOffsetJob subjob = new UpdateDstOffsetJob(accounts);
	System.enqueueJob(subjob);
}