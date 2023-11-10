trigger UpdateSoloPointBySoloRankMatch on SoloMatchResult__c(after insert) {
  List<SoloMatchResult__c> resultList = Trigger.new;
  SoloMatchResult__c result = resultList[0];

  Id participantId = result.Participant__c;
  List<Contact> participantList = [
    SELECT Id, Name, TotalSoloPoint__c
    FROM Contact
    WHERE Id = :participantId
  ];

  Contact participant = participantList[0];
  participant.TotalSoloPoint__c += result.PointForParticipant__c;

  update participant;

  Id opponentId = result.Opponent__c;
  // TODO: 冗長。取得メソッドは再利用するのでApexクラスに移したい。
  List<Contact> opponentList = [
    SELECT Id, Name, TotalSoloPoint__c
    FROM Contact
    WHERE Id = :opponentId
  ];

  Contact opponent = opponentList[0];
  opponent.TotalSoloPoint__c += result.PointForOpponent__c;

  // TODO: Listでまとめて一括DMLでUpdateできないか。
  update opponent;
}
