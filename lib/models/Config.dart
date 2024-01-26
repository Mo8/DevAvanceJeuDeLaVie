class Config {
  final Set<int> born;
  final Set<int> survive;

  const Config({required this.born, required this.survive});

  Config.parse(String toParse): born = {}, survive = {} {
    String alive = toParse.split("A")[0];
    String dead = toParse.split("A")[1].split("D")[0];

    for(int i = 0; i < alive.length; i++){
      survive.add(int.parse(alive[i]));
    }

    for(int i = 0; i < dead.length; i++){
      born.add(int.parse(dead[i]));
    }

  }

}