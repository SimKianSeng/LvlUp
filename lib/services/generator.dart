import 'dart:math';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity
class Generator {

  static final Generator _instance = Generator._internal();

  List<String> modules = [];
  late int intensity;
  late List<DateTime> sessions;
  List<String> allocations = [];

  factory Generator() {
    return _instance;
  }

  Generator._internal();

  bool alreadyInput(String module) {
    return modules.contains(module);
  }

  void addModuleRanked(String module, int rank) {
    print('added');
    modules.insert(rank - 1, module);
  }

  bool isAdded(int rank) {
    bool moduleAdded = modules.length != rank;
    
    return moduleAdded;
  }

  void removeModule(String module) {
    print('removed');
    modules.remove(module);
  }

  // void addSessions(List<DateTime> sessions) {
  //   this.sessions = sessions;
  // }

  void updateIntensity(int intensity) {
    this.intensity = intensity;
  }

  List<String> generateSchedule() {
    int numberOfFreeSessions = 5; //sessions.length;


    while (numberOfFreeSessions != 0) {
      String module = selectModule();

      allocations.add(module);

      numberOfFreeSessions -= 1;
    }

    return allocations;
  }

  
  String selectModule() {
    //Save the need to compute everytime if there is no modules
    if (modules.isEmpty) {
      return 'free';
    }

    if (!modules.contains('free')) {
      modules.add('free');
    }

    //Corresponds to modules index
    List<int> prefixSum = [];
    
    for (int i = 1; i <= modules.length; i++) {
      int rank = modules.length - i;
      prefixSum.add((rank * rank) ~/ 2);
    }

    int totalPriorities = (((1 + modules.length) * (modules.length)) ~/ 2) ~/ (1 - (intensity / 10));

    int target = 1 + Random().nextInt(totalPriorities);

    //Binary search to find smallest index corresponding to prefix sum greater than target
    int start = 0;
    int end = prefixSum.length - 1;

    while(start < end) {
      int mid = (start + end) ~/ 2;
      if (prefixSum[mid] < target) {
        start = mid + 1;
      } else if (prefixSum[mid] > target) {
        end = mid;
      } else {
        start = mid;
        break;
      }
    }


    String module = modules[start];
    return module;
  }
  
}