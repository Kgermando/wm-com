import 'dart:developer';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PaginationController extends GetxController {
  PaginationController(this.stateManager, this.numOfItemsPerPage, this.fetchItems);

  PlutoGridStateManager stateManager;

  final int numOfItemsPerPage;
  final RxInt _currentPageNum = 1.obs;
  RxInt get currentPageNum => _currentPageNum;

  final RxInt numOfAllItems = 0.obs;

  final RxInt _numOfPages = 1.obs;
  RxInt get numOfPages => _numOfPages;

  /// the function is called when loading a new page (in pagination)
  final Future<List<PlutoRow>> Function(int pageNum, int numOfItemsPerPage) fetchItems;
 
  /// pages are stores in this map
  Map<int, List<PlutoRow>> pages = {};
  bool isPageLoaded(int pageNum) => pages[pageNum] == null ? false : true;

  @override
  void onInit() {
    stateManager.setPageSize(numOfItemsPerPage, notify: false);
    fetchItems(currentPageNum.value, numOfItemsPerPage);
    super.onInit();
  }

  void setAllItemsNumber(int numOfAllItems) {
    this.numOfAllItems(numOfAllItems);
  }

  void setNumOfPages(int numOfPages) {
    _numOfPages(numOfPages);
  }

  /// replace the old page with the newly selected page
  Future<void> setSelectedPage(int selectedPageNum) async {
    _currentPageNum.value = selectedPageNum;
    log('selected page: $_currentPageNum');

    /// if the selected page is not loaded then => download it
    if (!isPageLoaded(_currentPageNum.value)) {
      await loadPage(selectedPageNum);
    }
    stateManager.removeAllRows(notify: false);
    stateManager.appendRows(pages[selectedPageNum]!);
  }

  Future<void> loadPage(int selectedPageNum) async {
    stateManager.setShowLoading(true);

    final List<PlutoRow> newPageRows = await fetchItems(_currentPageNum.value, numOfItemsPerPage);
    stateManager.setShowLoading(false);

    pages[selectedPageNum] = newPageRows;
  }

  void initStateManager(PlutoGridStateManager stateManager) {
    this.stateManager = stateManager;
    setSelectedPage(_currentPageNum.value);
  }

  /// reomoves all the items stored and downloads the first page
  void refreshItems() {
    stateManager.removeAllRows();
    pages.clear();
    _currentPageNum(1);
    setSelectedPage(_currentPageNum.value);
  }
}
