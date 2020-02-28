trigger UpdateGmtOffsetOnContact on Contact(after update, after insert) {

    List<Contact> contacts = Trigger.new;
    //isExecuting mean that trigger inside web service or exec anon
    if (contacts.isEmpty() || !Trigger.isExecuting || !TimeUtil.isGeocodesChanged(Trigger.old, Trigger.new)) {
        return;
    }

    UpdateDstOffsetJob subjob = new UpdateDstOffsetJob(contacts);
    System.enqueueJob(subjob);
}