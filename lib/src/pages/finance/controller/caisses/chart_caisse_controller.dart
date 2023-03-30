import 'package:get/get.dart';
import 'package:wm_com/src/global/api/finance/caisse_api.dart';
import 'package:wm_com/src/models/finance/chart_multi.dart';

class ChartCaisseController extends GetxController
    with StateMixin<List<ChartFinanceModel>> {
  final CaisseApi caisseApi = CaisseApi();

  var chartList = <ChartFinanceModel>[].obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    _isLoading.value = true;
    await caisseApi.getAllDataChart().then((response) {
      chartList.clear();
      chartList.assignAll(response);
      change(chartList, status: RxStatus.success());
      _isLoading.value = false;
    }, onError: (err) {
      _isLoading.value = false;
      change(null, status: RxStatus.error(err.toString()));
    });
  }
}
