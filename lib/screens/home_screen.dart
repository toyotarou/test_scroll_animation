import 'package:flutter/material.dart';

import '../models/jewellery.dart';
import '../repository/jewellery_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Categories keys
  final List<GlobalKey> jewelleryCategories = [GlobalKey(), GlobalKey(), GlobalKey()];

  /// Scroll Controller
  late ScrollController scrollController;

  /// Tab Context
  BuildContext? tabContext;

  ///
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
    super.initState();
  }

  ///
  void animateToTab() {
    late RenderBox box;

    for (var i = 0; i < jewelleryCategories.length; i++) {
      /// 治し方がわからない
      box = jewelleryCategories[i].currentContext!.findRenderObject() as RenderBox;

      final position = box.localToGlobal(Offset.zero);

      if (scrollController.offset >= position.dy) {
        DefaultTabController.of(tabContext!).animateTo(i, duration: const Duration(milliseconds: 100));
      }
    }
  }

  ///
  Future<void> scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);

    final categories = jewelleryCategories[index].currentContext!;

    await Scrollable.ensureVisible(categories, duration: const Duration(milliseconds: 600));

    scrollController.addListener(animateToTab);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          tabContext = context;
          return Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  /// Earnings Title - Content
                  _buildCategoryTitle('Earnings', 0),
                  _buildItemList(JewelleryRepository.earnings),

                  /// Ring Title - Content
                  _buildCategoryTitle('Ring', 1),
                  _buildItemList(JewelleryRepository.ring),

                  /// Diamonds Title - Content
                  _buildCategoryTitle('Diamond', 2),
                  _buildItemList(JewelleryRepository.diamond),

                  /// Empty Bottom space
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Title'),
      centerTitle: true,
      bottom: TabBar(
        tabs: const [Tab(child: Text('Earnings')), Tab(child: Text('Ring')), Tab(child: Text('Diamond'))],
        onTap: scrollToIndex,
      ),
    );
  }

  ///
  Widget _buildItemList(List<JewelleryModel> categories) {
    return Column(children: categories.map(_buildSingleItem).toList());
  }

  ///
  Widget _buildSingleItem(JewelleryModel item) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 160,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(item.image, fit: BoxFit.cover),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          item.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('€${item.price}', style: const TextStyle(fontSize: 16, color: Colors.black)),
                                  const SizedBox(width: 10),
                                  Text(
                                    '€${item.price + 26.07}',
                                    style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_back_ios_sharp)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  ///
  Widget _buildCategoryTitle(String title, int index) {
    return Padding(
      key: jewelleryCategories[index],
      padding: const EdgeInsets.only(top: 14, right: 12, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View more',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.indigo),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
