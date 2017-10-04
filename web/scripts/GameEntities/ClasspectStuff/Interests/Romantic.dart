import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Romantic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.RELATIONSHIPS, 2.0, true)]);
    @override
    List<String> handles1 = <String>["wishful", "matchmaking", "passionate", "kinky", "romantic", "serendipitous", "true", "hearts", "blushing", "precious", "warm", "serenading", "mesmerizing", "mirrored", "pairing", "perverse"];

    @override
    List<String> handles2 =<String>["Romantic", "Dreamer", "Beau", "Hearthrob", "Virtue", "Beauty", "Rainbow", "Heart", "Magnet", "Miracle", "Serendipity", "Team"];

    @override
    List<String> levels = <String>["QUESTING CUPID", "ROMANCE EXPERT"];

    @override
    List<String> interestStrings = <String>["Girls", "Boys", "Romance", "Shipping", "Relationships", "Love", "Romantic Comedies", "Fate", "Dating"];


    Romantic() :super(12, "Romantic", "romantic", "obsessive");

    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Shipping","Ports","Ships", "Docks", "Sails", "Matchmaking", "Cupids", "Fleets"])
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Ship All the Ships", [
                new Quest("The ${Quest.PLAYER1} begins constructing an intricate map of all possible relationships and all ideal relationships for a group of consorts. The ${Quest.CONSORT}s have no idea what's coming. "),
                new Quest("The ${Quest.PLAYER1}extends their “shipping grid” to include the entire ${Quest.CONSORT} population, and begins subtly pushing to make these ships a reality. Happy ${Quest.CONSORTSOUND}s ring out through the air.  "),
                new Quest("The ${Quest.PLAYER1} finds the ABSOLUTE BEST SHIP ever, and it's not even banned by the ${Quest.DENIZEN}'s stupid rules. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PreDenizenQuestChain("Flushed Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be getting along well. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a heart symbol on the door. They ignore all common sense and venture inside. Chocolates and roses abound. There is a couch, and a romantic movie playing. Huh. ")
            ], new FlushedRomanceReward(), QuestChainFeature.twoPlayers), Feature.MEDIUM)

            ..addFeature(new PreDenizenQuestChain("Pale Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be a good complement to each other. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a diamond symbol on the door. They ignore all common sense and venture inside. Ice cream and hankies abound. There is a couch, and a sad movie playing. Huh. ")
            ], new PaleRomanceReward(), QuestChainFeature.twoPlayers), Feature.MEDIUM)

            ..addFeature(new PreDenizenQuestChain("Pitched Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be evenly matched rivals. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a spades symbol on the door. They ignore all common sense and venture inside. Non lethal weapons and games abound. There is a couch, and a controversial movie playing. Huh. ")
            ], new PitchRomanceReward(), QuestChainFeature.twoPlayers), Feature.MEDIUM)

            ,  Theme.LOW);
    }

}