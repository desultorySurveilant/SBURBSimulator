import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:collection';
import 'DeadAuthorBot.dart';
import "../../SessionEngine/DeadSessionSummary.dart";

//replaces the poorly named scenario_controller2.js
/*
  AB seems to treat sessions normally UNTIL they end. though I WILL override start session to avoid
  AB rewriting the page title.
 */
Random rand;
Player mvp;
int round = 0;
DeadSessionFinderController self; //want to access myself as more than just a sim controller occasionally
Future<Null> main() async {

  doNotRender = true;
  doNotFetchXml = true; //AB slows down like whoa.
  loadNavbar();
  await globalInit();

  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(SimController.instance.currentSessionForErrors,e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  new DeadSessionFinderController();
  self = SimController.instance;
  self.percentBullshit();

  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  self.formInit();
  if(SimController.shogun) doShogun();

}

void checkSessions() {
    startTime =new DateTime.now();
  self.checkSessions();
}

void filterSessionSummaries() {
  self.filterSessionSummaries();
}


//todo remove these if it turns out i can onclick to instance method
void toggleCorpse(){
  self.toggleCorpse();
}



void toggleRomance(){
  self.toggleRomance();
}



void toggleDrama(){
  self.toggleDrama();
}



void toggleMisc(){
  self.toggleMisc();
}



void toggleEnding(){
  self.toggleEnding();
}

void doShogun() {
  (querySelector("#avatar") as ImageElement).src = "images/Alchemy/abGlitch.gif";

}



void toggleAverage(){
  self.toggleAverage();
}




class DeadSessionFinderController extends DeadAuthorBot { //works exactly like Sim unless otherwise specified.
  bool displayRomance = true;
  bool displayEnding = true;
  bool displayDrama = true;
  bool displayCorpse = false;
  bool displayMisc = true;
  bool displayAverages = true;
  bool displayClasses = false;
  bool displayAspects = false;
  bool tournamentMode = false;
  void toggleCorpse() {
    toggle(querySelector('#multiSessionSummaryCorpseParty'));
    displayCorpse = !displayCorpse;
    if(displayCorpse){
      (querySelector("#avatar") as ImageElement).src = "images/corpse_party_robot_author.png";
    }else{
      (querySelector("#avatar") as ImageElement).src ="images/guide_bot.png";
    }
  }

  void filterSessionSummaries() {
    //;
    List<SessionSummary> tmp = [];
    List<String> filters = [];
    sessionSummariesDisplayed = [] ;//can filter already filtered arrays.;
    for(num i = 0; i<allSessionsSummaries.length; i++){
      sessionSummariesDisplayed.add(allSessionsSummaries[i]);
    }
    List<Element> filterCheckBoxes = querySelectorAll("input[name='filter']:checked");
    ////;
    for(CheckboxInputElement c in filterCheckBoxes) {
      filters.add(c.value);
    }
    ////;
    for(int i = 0; i<sessionSummariesDisplayed.length; i++){
      SessionSummary ss = sessionSummariesDisplayed[i];
      if(ss.satifies_filter_array(filters)){
        tmp.add(ss);
      }
    }

    List<SBURBClass> classes = [];
    List<Aspect> aspects = [];


    List<Element> filterAspects = querySelectorAll("input[name='filterAspect']:checked");
    for(CheckboxInputElement c in filterAspects) {
      aspects.add(Aspects.getByName(c.value));
    }

    List<Element> filterClasses = querySelectorAll("input[name='filterClass']:checked");
    for(CheckboxInputElement c in filterClasses) {
      classes.add(SBURBClassManager.stringToSBURBClass(c.value));
    }

    tmp = removeNonMatchingClasspects(tmp,classes,aspects);


    //////print(tmp);
    sessionSummariesDisplayed = tmp;
    ////;
    printSummaries();
    printStats(filters,classes, aspects);

  }



  void printSummaries(){
    setHtml(querySelector("#debug"), "");
    for(num i = 0; i<sessionSummariesDisplayed.length; i++){
      var ssd = sessionSummariesDisplayed[i];
      var str = ssd.generateHTML();
      debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(ssd) + "</font><Br>" );
      debug(str);
    }
  }



  List<SessionSummary> removeNonMatchingClasspects(List<SessionSummary> tmp, List<SBURBClass> classes, List<Aspect> aspects) {
    List<SessionSummary> toRemove = <SessionSummary>[];
    for(num i = 0; i<tmp.length; i++){
      SessionSummary ss = tmp[i];
      if(!ss.matchesClasspect(classes, aspects)){ //if no classes or aspects, thenexpect to return true
        toRemove.add(ss);
      }
    }

    for(num i = 0; i<toRemove.length; i++){
      removeFromArray(toRemove[i],tmp);
    }
    ////;

    return tmp;
  }

  void toggleAverage() {
    toggle(querySelector('#multiSessionSummaryAverage'));
    displayAverages = !displayAverages;
  }

  void toggleEnding() {
    toggle(querySelector('#multiSessionSummaryEnding'));
    displayEnding = !displayEnding;
  }

  void toggleMisc() {
    toggle(querySelector('#multiSessionSummaryMisc'));
    displayMisc = !displayMisc;
  }

  void toggleDrama() {
    toggle(querySelector('#multiSessionSummaryDrama'));
    displayDrama = !displayDrama;
  }

  void toggleRomance() {
    toggle(querySelector('#multiSessionSummaryRomance'));
    displayRomance = !displayRomance;
  }

  void percentBullshit(){
    double pr = 90+(new Random().nextDouble())*10; //this is not consuming randomness. what to do?
    setHtml(querySelector("#percentBullshit"), "$pr%");
  }

  void formInit(){
    querySelector("#button").onClick.listen((e) => checkSessions());
    (querySelector("#button")as ButtonElement).disabled =false;
    (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;

    querySelector("#num_sessions").onChange.listen((Event e) {
      (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;
    });
  }


  //stripped out tournament stuff, that'll be a different controller.
  @override
  SessionSummary summarizeSession(Session session) {
    ////;
    ////print("summarizing: " + curSessionGlobalVar.session_id + " please ignore: " +curSessionGlobalVar.pleaseIgnoreThisSessionAB);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if (sessionsSimulated.indexOf(session.session_id) != -1 &&
        !session.stats.scratched) { //scratches are allowed to be repeats
      ////print("Debugging AB: should be skipping a repeat session: " +session.session_id.toString());
      return null;
    }
    sessionsSimulated.add(session.session_id);
    SessionSummary sum = session.generateSummary();
    setHtml(SimController.instance.storyElement, "");
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats(null,null,null); //no filters here
    numSimulationsDone ++;
    initial_seed = session.rand.nextInt(); //child session
    ////;
    if(numSimulationsDone >= numSimulationsToDo){
      round ++;
      (querySelector("#button")as ButtonElement).disabled =false;
     // //;
      stopTime = new DateTime.now();
      if(mvp == null)       getMVP(session);
      appendHtml(querySelector("#roundTime"), "Round: MVP: ${mvp.htmlTitleBasicNoTip()} with Power ${mvp.getStat(Stats.POWER).round()} and Grist ${mvp.grist.round()}, $round took ${stopTime.difference(startTime)}<br>");
      mvp = null; //reset.
      window.alert("Notice: should be ready to check more sessions.");
           List<Element> filters = querySelectorAll("input[name='filter']");
      for(CheckboxInputElement e in filters) {
        e.disabled = false;
      }
    }else{
     // //;
      //new Timer(new Duration(milliseconds: 10), () => startSession()); //sweet sweet async
      //RESETTING the mutator so that wastes can't leak into other sessions
      getMVP(session);
      new SessionMutator(); //will auto set itself to instance, handles resetting whatever needs resetting in other files
      window.requestAnimationFrame((num t) {
        Session session = new DeadSession(SimController.instance.initial_seed);
        startSessionThenSummarize(session);
      });
    }
    ////;
    return sum;
  }

  void getMVP(Session session) {
    if(mvp == null) {
      mvp = findMVP(session.players);
    }else {
      Player tmp = findMVP(session.players);
      //this way makes SURE it uses the same metric as findMVP
      mvp = findMVP(<Player>[mvp, tmp]);
    }
  }

  @override
  SessionSummary summarizeSessionNoFollowup(Session session) {
    ////print("no timeout summarizing: " + curSessionGlobalVar.session_id);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if(sessionsSimulated.indexOf(session.session_id) != -1){
      //////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);
      return null;
    }
    sessionsSimulated.add(session.session_id);
    setHtml(SimController.instance.storyElement, "");
    var sum = session.generateSummary();
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats(null, null, null); //not filtering anything
    return sum;
  }


  //none can be inline anymore
  void wireUpAllCheckBoxesAndButtons() {
    wireUpAllFilters();
    wireUpAllButtons();
  }

  void wireUpAllFilters() {
    //except for corpse party apparently
    List<Element> allFilters = querySelectorAll("input[name='filter']");
   // //;
    for(CheckboxInputElement e in allFilters) {
      e.onChange.listen((e) => filterSessionSummaries());
    }


    List<Element> classFilters = querySelectorAll("input[name='filterClass']");
    ////;
    for(CheckboxInputElement e in classFilters) {
      e.onChange.listen((e) => filterSessionSummaries());
    }

    List<Element> aspectFilters = querySelectorAll("input[name='filterAspect']");
    ////;
    for(CheckboxInputElement e in aspectFilters) {
      e.onChange.listen((e) => filterSessionSummaries());
    }
  }


  //can't be in session summary cuz needs globals only found here, or instance methods only found here.
  void wireUpAllButtons() {
    if(querySelector("#corpseButton") != null) querySelector("#corpseButton").onClick.listen((e) => toggleCorpse());
    if(querySelector("#romanceButton") != null) querySelector("#romanceButton").onClick.listen((e) => toggleRomance());
    if(querySelector("#dramaButton") != null) querySelector("#dramaButton").onClick.listen((e) => toggleDrama());
    if(querySelector("#miscButton") != null) querySelector("#miscButton").onClick.listen((e) => toggleMisc());
    if(querySelector("#endingButton") != null) querySelector("#endingButton").onClick.listen((e) => toggleEnding());
    if(querySelector("#averageButton") != null) querySelector("#averageButton").onClick.listen((e) => toggleAverage());
  }

  void printStats(List<String> filters, List<SBURBClass> classes, List<Aspect> aspects) {
    DeadMultiSessionSummary mms;
    if(sessionSummariesDisplayed.isEmpty) {
      mms = new DeadMultiSessionSummary(); //don't try to collate nothing, wont' fail gracefully like javascript did
    }else {
      mms = DeadMultiSessionSummary.collateMultipleSessionSummaries(sessionSummariesDisplayed);
    }

    ;
    setHtml(querySelector("#stats"), mms.generateHTML());
    mms.wireUpCorpsePartyCheckBoxes();
    wireUpAllCheckBoxesAndButtons();

    if(displayMisc) show(querySelector('#multiSessionSummaryMisc'));  //memory. don't always turn off when making new ones.
    if(!displayMisc) hide(querySelector('#multiSessionSummaryMisc'));

    if(displayRomance) show(querySelector('#multiSessionSummaryRomance'));  //memory. don't always turn off when making new ones.
    if(!displayRomance)hide(querySelector('#multiSessionSummaryRomance'));

    if(displayDrama) show(querySelector('#multiSessionSummaryDrama'));  //memory. don't always turn off when making new ones.
    if(!displayDrama)hide(querySelector('#multiSessionSummaryDrama'));

    if(displayEnding) show(querySelector('#multiSessionSummaryEnding'));  //memory. don't always turn off when making new ones.
    if(!displayEnding)hide(querySelector('#multiSessionSummaryEnding'));

    if(displayAverages)show(querySelector('#multiSessionSummaryAverage'));  //memory. don't always turn off when making new ones.
    if(!displayAverages)hide(querySelector('#multiSessionSummaryAverage'));

    if(displayCorpse) show(querySelector('#multiSessionSummaryCorpseParty')); //memory. don't always turn off when making new ones.
    if(!displayCorpse)hide(querySelector('#multiSessionSummaryCorpseParty'));

    if(filters != null){
      List<Element> allFilters = querySelectorAll("input[name='filter']");
      for(CheckboxInputElement e in allFilters) {
        e.disabled = false;
        if(filters.contains(e.value)){
          e.checked = true;
        }else{
          e.checked = false;
        }
      }
    }

    if(classes != null && aspects != null){
      List<Element> filterClass = querySelectorAll("input[name='filterClass']");
      for(CheckboxInputElement e in filterClass) {
        e.disabled = false;
        if(classes.contains(SBURBClassManager.stringToSBURBClass(e.value))){
          e.checked = true;
        }else{
          e.checked = false;
        }

      }

      List<Element> filterAspect = querySelectorAll("input[name='filterAspect']");
      for(CheckboxInputElement e in filterAspect) {
        e.disabled = false;
        if(aspects.contains(Aspects.getByName(e.value))){
          e.checked = true;
        }else{
          e.checked = false;
        }

      }

    }

  }
}