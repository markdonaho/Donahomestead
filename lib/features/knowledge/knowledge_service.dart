import 'package:cloud_firestore/cloud_firestore.dart';
import 'knowledge_model.dart';

class KnowledgeService {
  final CollectionReference _knowledgeCollection =
      FirebaseFirestore.instance.collection('knowledge_items');

  // Get all knowledge items
  Stream<List<KnowledgeItem>> getKnowledgeItems() {
    return _knowledgeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => KnowledgeItem.fromSnapshot(doc)).toList();
    });
  }

  // Add new item
  Future<void> addKnowledgeItem(KnowledgeItem item) async {
    await _knowledgeCollection.add(item.toMap());
  }

  // Update existing item
  Future<void> updateKnowledgeItem(KnowledgeItem item) async {
    await _knowledgeCollection.doc(item.id).update(item.toMap());
  }

  // Delete item
  Future<void> deleteKnowledgeItem(String id) async {
    await _knowledgeCollection.doc(id).delete();
  }

  // Get Learning Center Playlist ID
  Future<String> getLearningCenterPlaylistId() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('learning_center')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('playlistId')) {
          return data['playlistId'] as String;
        }
      }
    } catch (e) {
      // Ignore errors and return default
      print('Error fetching playlist ID: $e');
    }

    return 'PLAnbjvO8DSpd7K7APVtil6OgjMKsBaQGk';
  }

  // Seed Chicken Knowledge
  Future<void> seedChickenKnowledge() async {
    final List<Map<String, dynamic>> chickenItems = [
      {
        'title': 'Bumblefoot',
        'category': 'Chicken',
        'content': 'Staph infection on foot pad. Look for a black scab. Treatment: Soak in Epsom salts, remove scab, apply antibiotic ointment, and wrap. Keep clean.',
      },
      {
        'title': 'Mites',
        'category': 'Chicken',
        'content': 'Tiny external parasites that suck blood. Look for grey bugs around the vent. Treatment: Dust birds with Permethrin or use Elector PSP. Clean coop thoroughly.',
      },
      {
        'title': 'Lice',
        'category': 'Chicken',
        'content': 'External parasites that live at the base of feathers. Look for white egg clumps (nits) on feather shafts near the vent. Treatment: Permethrin dust or spray.',
      },
      {
        'title': 'Coccidiosis',
        'category': 'Chicken',
        'content': 'Intestinal parasite common in chicks. Symptoms: Bloody poop, lethargy, ruffled feathers. Treatment: Corid (Amprolium) in water for 5-7 days.',
      },
      {
        'title': 'Egg Bound',
        'category': 'Chicken',
        'content': 'Hen cannot pass an egg. Symptoms: Penguin walking, straining, lethargy. Treatment: Warm Epsom salt bath, calcium supplement, lubricant inside vent.',
      },
      {
        'title': 'Sour Crop',
        'category': 'Chicken',
        'content': 'Fungal infection (Yeast) in the crop. Symptoms: Squishy, fluid-filled crop, foul smell from mouth. Treatment: Antifungal (Nystatin), copper sulfate, or acidified water.',
      },
      {
        'title': 'Impacted Crop',
        'category': 'Chicken',
        'content': 'Blockage in the crop (grass, straw). Symptoms: Hard, large crop that doesn\'t empty overnight. Treatment: Oil massage, plenty of water, surgery in severe cases.',
      },
      {
        'title': 'Frostbite',
        'category': 'Chicken',
        'content': 'Damage to combs and wattles from freezing temps. Prevention: Good ventilation (low humidity), Vaseline on combs. Treatment: Do not rub! Let it heal naturally.',
      },
      {
        'title': 'Heat Stress',
        'category': 'Chicken',
        'content': 'Overheating. Symptoms: Panting, wings held out, pale comb. Treatment: Cool water, electrolytes, shade, frozen treats, mister.',
      },
      {
        'title': 'Molting',
        'category': 'Chicken',
        'content': 'Annual feather loss and regrowth. Hens stop laying. Support: High protein feed (20%+), minimize stress. Do not handle them much (pin feathers hurt).',
      },
      {
        'title': 'Broodiness',
        'category': 'Chicken',
        'content': 'Hen insisting on sitting on eggs. Breaking: Remove from nest frequently, use a "broody breaker" wire cage with no bedding for 3 days.',
      },
      {
        'title': 'Pasty Butt',
        'category': 'Chicken',
        'content': 'Poop sticking to a chick\'s vent, blocking it. Fatal if untreated. Treatment: Gently clean with warm wet cloth/paper towel. Apply oil/Vaseline to prevent sticking.',
      },
      {
        'title': 'Scaly Leg Mites',
        'category': 'Chicken',
        'content': 'Mites burrowing under leg scales. Symptoms: Raised, crusty scales. Treatment: Smother mites by coating legs in Vaseline or oil regularly.',
      },
      {
        'title': 'Wry Neck',
        'category': 'Chicken',
        'content': 'Twisted neck, looking up or backwards. Vitamin deficiency or injury. Treatment: Vitamin E and Selenium supplements.',
      },
      {
        'title': 'Respiratory Infection',
        'category': 'Chicken',
        'content': 'Sneezing, coughing, bubbles in eyes, rattling breath. Treatment: Isolate immediately. Antibiotics (VetRx, Tylosin) may be needed. Consult vet if possible.',
      },
      {
        'title': 'Egg Eating',
        'category': 'Chicken',
        'content': 'Bad habit of eating their own eggs. Prevention: Collect eggs often, ceramic nest eggs, darken nest boxes, ensure enough protein/calcium.',
      },
      {
        'title': 'Feather Picking',
        'category': 'Chicken',
        'content': 'Bullying or protein deficiency. Treatment: Apply Blue-Kote to wounds (hides red), increase protein, provide boredom busters.',
      },
      {
        'title': 'Vent Gleet',
        'category': 'Chicken',
        'content': 'Fungal infection of the cloaca (Thrush). Symptoms: White discharge, red vent, bad smell. Treatment: Probiotics, antifungal cream, acidified water.',
      },
      {
        'title': 'Water Belly (Ascites)',
        'category': 'Chicken',
        'content': 'Fluid retention in abdomen due to heart failure. Symptoms: Swollen, squishy belly, purple comb. Treatment: Draining fluid (palliative), no cure.',
      },
      {
        'title': 'Gapeworm',
        'category': 'Chicken',
        'content': 'Red worms in the trachea. Symptoms: Gasping for air, shaking head. Treatment: Dewormer (Fenbendazole/Safe-Guard).',
      },
      {
        'title': 'Flystrike',
        'category': 'Chicken',
        'content': 'Maggots infesting a wound or dirty vent. Emergency! Treatment: Wash off maggots, remove necrotic tissue, apply spray, keep indoors.',
      }
    ];

    final batch = FirebaseFirestore.instance.batch();

    for (var item in chickenItems) {
      final docRef = _knowledgeCollection.doc();
      batch.set(docRef, item);
    }

    await batch.commit();
  }

  // Seed Tree Knowledge
  Future<void> seedTreeKnowledge() async {
    final List<Map<String, dynamic>> treeItems = [
      // General
      {
        'title': 'Planting Trees',
        'category': 'Tree',
        'content': 'Dig hole 2x root ball width. Do not bury graft union (bump on trunk). Water deeply immediately. Stake if necessary for first year.',
      },
      {
        'title': 'Watering Trees',
        'category': 'Tree',
        'content': 'Deep watering once a week (10-15 gal) is better than frequent shallow watering. Promotes deep root growth. Water more in heat waves.',
      },
      {
        'title': 'Mulching',
        'category': 'Tree',
        'content': 'Create a "donut" shape, not a "volcano". Keep mulch 3-4 inches away from trunk to prevent rot. Mulch helps retain moisture and suppress weeds.',
      },
      {
        'title': 'Pruning Basics',
        'category': 'Tree',
        'content': 'Remove "Dead, Diseased, Damaged" (3 Ds) wood first. Open center for airflow. Prune in late winter while dormant.',
      },
      // Apple
      {
        'title': 'Apple Scab',
        'category': 'Tree',
        'content': 'Fungal disease. Olive-green spots on leaves/fruit. Treatment: Fungicide (Captan/Sulfur), clean up fallen leaves in fall to reduce spores.',
      },
      {
        'title': 'Fire Blight',
        'category': 'Tree',
        'content': 'Bacterial. "Shepherd\'s crook" burnt tips. Treatment: Prune 12" below damage (sanitize tools with alcohol between cuts!). Avoid high nitrogen fertilizer.',
      },
      {
        'title': 'Codling Moth',
        'category': 'Tree',
        'content': 'Worm in the apple. Prevention: Pheromone traps, bagging fruit, Kaolin clay spray. Clean up dropped fruit immediately.',
      },
      {
        'title': 'Cedar Apple Rust',
        'category': 'Tree',
        'content': 'Orange spots on leaves. Needs cedar trees nearby to cycle. Treatment: Resistant varieties, fungicide spray in spring.',
      },
      {
        'title': 'Apple Maggot',
        'category': 'Tree',
        'content': 'Tunnels in fruit. Prevention: Red sticky sphere traps hung in tree. Pick up dropped fruit.',
      },
      {
        'title': 'Thinning Apples',
        'category': 'Tree',
        'content': 'Remove excess fruit to 1 per cluster (6" apart) when they are marble-sized. Ensures better size and prevents biennial bearing.',
      },
      // Pear
      {
        'title': 'Pear Psylla',
        'category': 'Tree',
        'content': 'Sap-sucking pest. Sticky "honeydew" on leaves leads to sooty mold. Treatment: Dormant oil spray, insecticidal soap.',
      },
      {
        'title': 'Pear Rust',
        'category': 'Tree',
        'content': 'Orange spots similar to apple rust. Treatment: Fungicide. Usually cosmetic but can be severe.',
      },
      {
        'title': 'Fire Blight (Pear)',
        'category': 'Tree',
        'content': 'Pears are very susceptible. Watch closely for blackened blooms/shoots. Prune aggressively 12" below infection.',
      },
      {
        'title': 'Harvesting Pears',
        'category': 'Tree',
        'content': 'Pick when mature but hard (tilt test: lift fruit, if it snaps off, it\'s ready). Ripen indoors for best texture. Tree-ripened pears are gritty.',
      },
      // Fig
      {
        'title': 'Fig Rust',
        'category': 'Tree',
        'content': 'Brown spots on leaves, early leaf drop. Treatment: Copper fungicide, clean up leaves. Usually strikes late season.',
      },
      {
        'title': 'Fig Mosaic Virus',
        'category': 'Tree',
        'content': 'Yellow spotting/mottling on leaves. No cure, but usually manageable with good care (water/fertilizer). Most figs have it.',
      },
      {
        'title': 'Winter Protection (Figs)',
        'category': 'Tree',
        'content': 'Figs are sensitive to cold. Wrap in burlap/leaves or bury if in Zone 6 or colder. Uncover after last frost.',
      },
      {
        'title': 'Pruning Figs',
        'category': 'Tree',
        'content': 'Prune heavily in late winter to stimulate new growth (where fruit forms). Remove dead wood and suckers.',
      },
      {
        'title': 'Birds/Ants on Figs',
        'category': 'Tree',
        'content': 'Pests eating ripe fruit. Prevention: Organza bags or netting for birds, Tanglefoot on trunk for ants (wrap trunk with tape first!).',
      },
      {
        'title': 'Root Knot Nematodes',
        'category': 'Tree',
        'content': 'Stunted growth, knots on roots. Prevention: Heavy mulch, plant marigolds nearby. No chemical cure.',
      },
      // Other
      {
        'title': 'Aphids',
        'category': 'Tree',
        'content': 'Sticky leaves, curled tips. Treatment: Blast with water hose, release Ladybugs.',
      },
      {
        'title': 'Scale',
        'category': 'Tree',
        'content': 'Bumps on bark that don\'t move. Treatment: Dormant oil spray in late winter to smother them.',
      },
      {
        'title': 'Japanese Beetles',
        'category': 'Tree',
        'content': 'Skeletonized leaves. Treatment: Hand pick into soapy water in early morning. Do not use pheromone traps (they attract more!).',
      }
    ];

    final batch = FirebaseFirestore.instance.batch();

    for (var item in treeItems) {
      final docRef = _knowledgeCollection.doc();
      batch.set(docRef, item);
    }

    await batch.commit();
  }

  // Seed Garden Knowledge
  Future<void> seedGardenKnowledge() async {
    final List<Map<String, dynamic>> gardenItems = [
      // Solanaceous
      {
        'title': 'Tomato (General)',
        'category': 'Veggie',
        'content': 'Plant deep (bury stem up to top leaves) to encourage root growth. Consistent water prevents splitting. Needs full sun.',
      },
      {
        'title': 'Tomato Pruning',
        'category': 'Veggie',
        'content': 'Remove suckers (shoots between stem and branch) for better airflow and larger fruit on indeterminate varieties. Keep leaves off the ground.',
      },
      {
        'title': 'Blossom End Rot',
        'category': 'Veggie',
        'content': 'Black leathery spot on bottom of tomatoes/peppers. Calcium deficiency usually caused by uneven watering. Mulch heavily to keep soil moisture consistent!',
      },
      {
        'title': 'Peppers',
        'category': 'Veggie',
        'content': 'Hot & Sweet. Magnesium lover (add Epsom salts to soil). Stake heavy producers. Start seeds indoors 8-10 weeks before frost.',
      },
      {
        'title': 'Potato (Planting)',
        'category': 'Veggie',
        'content': 'Plant seed potatoes 4" deep when soil warms. "Chit" (sprout) them first. Cut large ones in half (let scab over).',
      },
      {
        'title': 'Potato (Hilling)',
        'category': 'Veggie',
        'content': 'Cover stems with soil/straw as they grow to increase yield and prevent green skins (solanine). Keep tubers covered!',
      },
      // Cucurbits
      {
        'title': 'Cucumber',
        'category': 'Veggie',
        'content': 'Heavy feeder. Trellis to save space and keep fruit straight. Water base, not leaves, to prevent powdery mildew.',
      },
      {
        'title': 'Cucumber Beetles',
        'category': 'Veggie',
        'content': 'Yellow striped/spotted beetles. Transmit bacterial wilt (fatal). Hand pick or use yellow sticky traps. Cover young plants.',
      },
      {
        'title': 'Squash Vine Borer',
        'category': 'Veggie',
        'content': 'Moth lays eggs at base. Larva bores into stem, killing plant. Wrap base with foil or perform surgery to remove larva.',
      },
      {
        'title': 'Squash Bugs',
        'category': 'Veggie',
        'content': 'Grey/Bronze bugs, copper eggs under leaves. Hand pick daily. Place board on soil overnight and check under it in morning.',
      },
      {
        'title': 'Zucchini',
        'category': 'Veggie',
        'content': 'Harvest young (6-8") for best flavor. Check daily (they grow fast!). One plant is usually enough!',
      },
      {
        'title': 'Watermelon',
        'category': 'Veggie',
        'content': 'Ripe when "field spot" (bottom) turns yellow and the curly tendril nearest the stem dries up completely.',
      },
      // Legumes
      {
        'title': 'Green Beans',
        'category': 'Veggie',
        'content': 'Bush vs. Pole. Bush = all at once (good for canning). Pole = continuous harvest. Pick often to keep them producing.',
      },
      {
        'title': 'Peas',
        'category': 'Veggie',
        'content': 'Cool weather crop. Plant early spring. Sugar Snap (eat pod) vs. Shelling (remove pod). Soak seeds overnight before planting.',
      },
      {
        'title': 'Legume Inoculant',
        'category': 'Veggie',
        'content': 'Black powder (rhizobia bacteria) helps beans/peas fix nitrogen from air. Coat seeds before planting for better growth.',
      },
      // Roots & Bulbs
      {
        'title': 'Carrot',
        'category': 'Veggie',
        'content': 'Sow surface shallow, keep moist (cover with board until sprouted). THINNING is crucial for size! Loose soil prevents forking.',
      },
      {
        'title': 'Onion',
        'category': 'Veggie',
        'content': 'Plant sets or starts. Heavy nitrogen feeder. Stop watering when tops fall over. Cure in sun/dry place.',
      },
      {
        'title': 'Garlic',
        'category': 'Veggie',
        'content': 'Plant in Fall. Harvest when lower 3-4 leaves brown/die back. Cure in shade for 2 weeks before storing.',
      },
      {
        'title': 'Radish',
        'category': 'Veggie',
        'content': 'Fast crop (25 days). Plant with carrots to mark rows. Spicy in hot weather, mild in cool weather.',
      },
      {
        'title': 'Beets',
        'category': 'Veggie',
        'content': 'Eat the greens too! Seeds are multi-germ (clusters), so thin to 1 plant. Roast roots for best flavor.',
      },
      // Leafy Greens
      {
        'title': 'Lettuce',
        'category': 'Veggie',
        'content': 'Cool weather. Bolts (turns bitter/seeds) in heat. Shade cloth helps extend season. Cut-and-come-again harvest.',
      },
      {
        'title': 'Spinach',
        'category': 'Veggie',
        'content': 'Very cold hardy. Overwinters well under cover. Plant in late fall for early spring harvest.',
      },
      {
        'title': 'Kale',
        'category': 'Veggie',
        'content': 'Sweetens after a frost. Pests: Cabbage worms (white butterflies). Use row cover or BT spray.',
      },
      // Perennials & Others
      {
        'title': 'Asparagus',
        'category': 'Veggie',
        'content': 'Perennial. Do not harvest first 2 years. Mulch heavily. Harvest spears until pencil thin, then let fern out.',
      },
      {
        'title': 'Rhubarb',
        'category': 'Veggie',
        'content': 'Perennial. Eat stalks only (leaves are toxic). Pull stalks, don\'t cut. Heavy feeder (manure).',
      },
      {
        'title': 'Strawberry',
        'category': 'Veggie',
        'content': 'Plant crowns with roots down, bud up (don\'t bury crown). Remove runners for bigger fruit. Renovate beds every 3-4 years.',
      },
      {
        'title': 'Okra',
        'category': 'Veggie',
        'content': 'Heat lover. Harvest pods small (3-4") or they get woody. Beautiful hibiscus-like flowers.',
      },
      {
        'title': 'Sweet Potato',
        'category': 'Veggie',
        'content': 'Plant "slips" (sprouts) in warm soil. Vining habit. Cure at high heat/humidity to sweeten before storing.',
      },
      {
        'title': 'Corn',
        'category': 'Veggie',
        'content': 'Wind pollinated. Plant in blocks (squares), not single rows, for full ears. Heavy nitrogen feeder.',
      },
      {
        'title': 'Basil',
        'category': 'Veggie',
        'content': 'Pinch off flowers to keep it bushy and sweet. Propagates easily in water. Plant near tomatoes.',
      }
    ];

    final batch = FirebaseFirestore.instance.batch();

    for (var item in gardenItems) {
      final docRef = _knowledgeCollection.doc();
      batch.set(docRef, item);
    }

    await batch.commit();
  }
}
