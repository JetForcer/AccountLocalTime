public class UpdateDstOffsetJob implements Database.AllowsCallouts, Queueable {

	private List<SObject> scope;

	public UpdateDstOffsetJob(List<sObject> scope) {
		this.scope = scope;
	}

	public void execute(System.QueueableContext context) {
		for (sObject obj : scope) {
			TimeUtil.fetchAndInsertData(obj);
		}
	}
}