public class UpdateDstOffsetJob implements Database.AllowsCallouts, Queueable {

	private List<SObject> scope;

	public UpdateDstOffsetJob(List<sObject> scope) {
		this.scope = scope;
	}

	public void execute(System.QueueableContext context) {
		List<Account> records = castAndGetRecords(scope);
		if (records.isEmpty()) {
			System.debug('records are empty');
		}

		for (Account acc : records) {
			BillingTimeUtil.fetchAndInsertData(acc.Id);
		}
	}

	private List<Account> castAndGetRecords(List<sObject> scope) {
		Schema.SObjectType sObjectType = scope.getSObjectType();
		if (sObjectType == null) {
			return new List<Account>();
		}

		String listType = 'List<' + sObjectType + '>';
		List<Account> result = (List<Account>)Type.forName(listType).newInstance();
		for (SObject next : scope) {
			result.add((Account)next);
		}

		return result;
	}
}