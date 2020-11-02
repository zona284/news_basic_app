import 'package:flutter/material.dart';

/**
 * Routes
 */
const ROUTE_DEFAULT = "/";
const ROUTE_POST_DETAIL = "/detil";
const ROUTE_SEARCH_PAGE = "/search";

/**
 * API URL
 */
//[START] production
const BASE_URL = "https://5f72ba9e6833480016a9bf3e.mockapi.io/";
//[END] production

const API_HEADLINE_SLIDER = BASE_URL + "api/v1/category/1/articles?p=1&limit=8";
const API_ARTICLE_BY_CATEGORY = BASE_URL + "api/v1/category/{id}/articles";

/**
 * Response Status
 */
const RESPONSE_HTTP_OK = [200,201];

/**
 * TextStyle
 */
const TextStyle CONST_LIST_HEADER_TEXT_STYLE = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87);
const TextStyle CONST_HEADER_TEXT_STYLE = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87);
const TextStyle CONST_SUBHEADER_TEXT_STYLE = TextStyle(fontSize: 14, color: Colors.black54);
const TextStyle CONST_LINK_TEXT_STYLE = TextStyle(fontSize: 14, color: Colors.blue);
const TextStyle CONST_DETAILPAGE_HEADER_TITLE_TEXT_STYLE = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87);
const TextStyle CONST_APPBAR_TITLE_TEXT_STYLE = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87);
const TextStyle CONST_APPBAR_SUBTITLE_TEXT_STYLE = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54);

/**
 * Color
 */
const Color CONST_COLOR_GRAY = Color.fromARGB(4, 0, 0, 0);