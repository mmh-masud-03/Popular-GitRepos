import 'package:flutter/material.dart';
import '../../domain/entities/repository.dart';
import '../widgets/details/details_tab.dart';
import '../widgets/details/features_tab.dart';
import '../widgets/details/overview_tab.dart';
import '../widgets/details/repository_header.dart';
import '../widgets/details/repository_tabs.dart';

class RepositoryDetailsPage extends StatefulWidget {
  final Repository repository;

  const RepositoryDetailsPage({super.key, required this.repository});

  @override
  State<RepositoryDetailsPage> createState() => _RepositoryDetailsPageState();
}

class _RepositoryDetailsPageState extends State<RepositoryDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          RepositoryHeader(
            repository: widget.repository,
            isScrolled: _isScrolled,
          ),
          RepositoryTabs(tabController: _tabController),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            OverviewTab(repository: widget.repository),
            DetailsTab(repository: widget.repository),
            FeaturesTab(repository: widget.repository),
          ],
        ),
      ),
    );
  }
}
