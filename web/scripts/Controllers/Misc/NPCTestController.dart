import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';



Element storyDiv;
main() {
    globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    curSessionGlobalVar = new Session(getRandomSeed());
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();



    Player p = curSessionGlobalVar.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(curSessionGlobalVar);

    appendHtml(storyDiv, "Carapaces are: ${curSessionGlobalVar.npcHandler.allNPCS} ");

    List<String> leprechaunsNames = new List<String>();
    for(int i = 0; i<20; i++) {
        Leprechaun l = Leprechaun.getLeprechaunForPlayer(p);
        leprechaunsNames.add("${l.name} (${l.highestStat})");
        p.companions.add(l);
    }
    appendHtml(storyDiv, "<br><Br>Leprechauns are: ${turnArrayIntoHumanSentence(leprechaunsNames)} ");



    for(Player p in curSessionGlobalVar.players) {
        p.initialize();
        Consort template = p.land.consortFeature.makeConsort(curSessionGlobalVar);
        //print("template is ${template.name}");

        appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} ${p.highestStat} ${p.lowestStat}  has land ${p.land}");
        for(int i = 0; i<3; i++) {
            Consort c = Consort.npcForPlayer(template, p);
            appendHtml(storyDiv, "<br><Br>${c.name} ");
        }
    }



}