public class UpdateDstOffsetJob implements Database.AllowsCallouts, Queueable {

	private List<SObject> scope;

	public UpdateDstOffsetJob(List<sObject> scope) {
		this.scope = scope;
	}

	public void execute(System.QueueableContext context) {
		for (sObject obj : scope) {
			if (obj instanceof Account) {
				localTimeJF.TimeUtil.fetchAndInsertAccountData(obj.Id);
			}
			else if (obj instanceof Lead) {
				localTimeJF.TimeUtil.fetchAndInsertLeadData(obj.Id);
			}
			else if (obj instanceof Contact) {
				localTimeJF.TimeUtil.fetchAndInsertContactData(obj.Id);
			}
		}
	}
}