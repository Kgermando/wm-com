class AgentCountModel {
  final int count;

  const AgentCountModel({required this.count});

  factory AgentCountModel.fromSQL(List<dynamic> row) {
    return AgentCountModel(count: row[0]);
  }

  factory AgentCountModel.fromJson(Map<String, dynamic> json) {
    return AgentCountModel(count: json['count']);
  }

  Map<String, dynamic> toJson({int? id}) {
    return {'count': count};
  }
}

class AgentPieChartModel {
  final String sexe;
  final int count;

  AgentPieChartModel({required this.sexe, required this.count});

  factory AgentPieChartModel.fromSQL(List<dynamic> row) {
    return AgentPieChartModel(
      sexe: row[0],
      count: row[1],
    );
  }

  factory AgentPieChartModel.fromJson(Map<String, dynamic> json) {
    return AgentPieChartModel(sexe: json['sexe'], count: json['count']);
  }

  Map<String, dynamic> toJson({int? id}) {
    return {'sexe': sexe, 'count': count};
  }
}

class ReservationPieChartModel {
  final String eventName;
  final int count;

  ReservationPieChartModel({required this.eventName, required this.count});

  factory ReservationPieChartModel.fromSQL(List<dynamic> row) {
    return ReservationPieChartModel(
      eventName: row[0],
      count: row[1],
    );
  }

  factory ReservationPieChartModel.fromJson(Map<String, dynamic> json) {
    return ReservationPieChartModel(
        eventName: json['eventName'], count: json['eventName']);
  }

  Map<String, dynamic> toJson() {
    return {'eventName': eventName, 'count': count};
  }
}
