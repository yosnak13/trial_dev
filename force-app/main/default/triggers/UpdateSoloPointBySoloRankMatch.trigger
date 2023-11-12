trigger UpdateSoloPointBySoloRankMatch on SoloMatchResult__c(after insert) {
  List<SoloMatchResult__c> resultList = Trigger.new;
  SoloMatchResult__c result = resultList[0];

  Id challengerId = result.Challenger__c;
  List<Contact> challengerList = [
    SELECT Id, Name, TotalSoloPoint__c
    FROM Contact
    WHERE Id = :challengerId
  ];

  Contact challenger = challengerList[0];
  challenger.TotalSoloPoint__c += result.PointForChallenger__c;

  Id opponentId = result.Opponent__c;
  // TODO: 冗長。取得メソッドは再利用するのでApexクラスに移したい。
  List<Contact> opponentList = [
    SELECT Id, Name, TotalSoloPoint__c
    FROM Contact
    WHERE Id = :opponentId
  ];

  Contact opponent = opponentList[0];
  opponent.TotalSoloPoint__c += result.PointForOpponent__c;

  List<Contact> acctsToUpdate = new List<Contact>();
  acctsToUpdate.add(challenger);
  acctsToUpdate.add(opponent);
  update acctsToUpdate;
}
