import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

class InfinityScroll extends StatefulWidget {
  ///
  ///```
  ///This is the role model of the infinity scroll
  ///
  ///you can learn from this
  const InfinityScroll({Key? key}) : super(key: key);

  @override
  State<InfinityScroll> createState() => _RestaurantNewsInfiniteState();
}

class _RestaurantNewsInfiniteState extends State<InfinityScroll> {
  static const _pageSize = 20;

  final PagingController<int, CharacterSummary> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 4);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener(
      (status) {
        if (status == PagingStatus.subsequentPageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Something went wrong while fetching a new page.',
              ),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => _pagingController.retryLastFailedRequest(),
              ),
            ),
          );
        }
      },
    );
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, CharacterSummary>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<CharacterSummary>(
          itemBuilder: (context, item, index) => ListTile(
            leading: Image.network(item.pictureUrl),
            title: Text(item.name),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class CharacterSummary {
  CharacterSummary({
    required this.id,
    required this.name,
    required this.pictureUrl,
  });

  factory CharacterSummary.fromJson(Map<String, dynamic> json) =>
      CharacterSummary(
        id: json['char_id'],
        name: json['name'],
        pictureUrl: json['img'],
      );

  final int id;
  final String name;
  final String pictureUrl;
}

class RemoteApi {
  static Future<List<CharacterSummary>> getCharacterList(
    int offset,
    int limit, {
    String? searchTerm,
  }) async =>
      http
          .get(
            _ApiUrlBuilder.characterList(offset, limit, searchTerm: searchTerm),
          )
          .mapFromResponse<List<CharacterSummary>, List<dynamic>>(
            (jsonArray) => _parseItemListFromJsonArray(
              jsonArray,
              (jsonObject) => CharacterSummary.fromJson(jsonObject),
            ),
          );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

// ignore: avoid_classes_with_only_static_members
class _ApiUrlBuilder {
  static const _baseUrl = 'https://www.breakingbadapi.com/api/';
  static const _charactersResource = 'characters/';

  static Uri characterList(
    int offset,
    int limit, {
    String? searchTerm,
  }) =>
      Uri.parse(
        '$_baseUrl$_charactersResource?'
        'offset=$offset'
        '&limit=$limit'
        '${_buildSearchTermQuery(searchTerm)}',
      );

  static String _buildSearchTermQuery(String? searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
