import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_cubit.dart';
import 'package:tap_invest_assignment/bloc/company_state.dart';
import 'package:tap_invest_assignment/model/company_model.dart';
import 'package:tap_invest_assignment/screens/company_details_screen.dart';
import 'package:tap_invest_assignment/utils/custom_container.dart';
import 'package:tap_invest_assignment/utils/custom_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyCubit>().fetchIssuers();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.lightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Home",
                style: theme.textTheme.titleLarge!.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  context.read<CompanyCubit>().search(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by Issuer Name or ISIN',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "SEARCH RESULTS",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CustomContainer(
                  child: BlocBuilder<CompanyCubit, CompanyState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        failure: (msg) => Center(child: Text(msg)),
                        loaded: (_, filtered) =>
                            _buildSearchResultsList(filtered),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList(List<CompanyModel> filtered) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(
        height: 0.1,
        indent: 4,
        endIndent: 4,
      ),
      itemBuilder: (_, index) {
        final item = filtered[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CompanyDetailsScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(item.logo, fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        buildHighlightedText(
                          text: item.isin,
                          query: searchQuery,
                          baseStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        buildHighlightedText(
                          text: '${item.rating} • ${item.companyName}',
                          query: searchQuery,
                          baseStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextSpan buildHighlightedText({
    required String text,
    required String query,
    required TextStyle baseStyle,
  }) {
    if (query.trim().isEmpty) return TextSpan(text: text, style: baseStyle);

    final words = query.trim().toLowerCase().split(RegExp(r'\s+'));
    final lowerText = text.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;

    while (start < text.length) {
      int matchStart = -1;
      int matchEnd = -1;
      // String matchedWord = '';
      for (var word in words) {
        final index = lowerText.indexOf(word, start);
        if (index != -1 && (matchStart == -1 || index < matchStart)) {
          matchStart = index;
          matchEnd = index + word.length;
          // matchedWord = word;
        }
      }

      if (matchStart == -1) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }

      if (matchStart > start) {
        spans.add(TextSpan(
            text: text.substring(start, matchStart), style: baseStyle));
      }

      spans.add(TextSpan(
        text: text.substring(matchStart, matchEnd),
        style: baseStyle.copyWith(
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.w700,
        ),
      ));

      start = matchEnd;
    }

    return TextSpan(children: spans);
  }

}
