import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:xkcd_mobx/constants.dart';
import 'package:xkcd_mobx/mobx/xkcd.dart';

class RandomComicScreen extends StatefulWidget {
  RandomComicScreen({Key key}) : super(key: key);

  @override
  _RandomComicScreenState createState() => _RandomComicScreenState();
}

class _RandomComicScreenState extends State<RandomComicScreen> {
  final XkcdService store = XkcdService();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat formatter = DateFormat('yMMMd');

  @override
  void initState() {
    getMainComic();
    super.initState();
  }

  getMainComic() async {
    await store.getRandomComic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bg,
        title: Center(child: Text('Random Comics')),
        actions: [
          Icon(
            Icons.more_horiz_outlined,
            color: bg,
          ),
          Icon(
            Icons.more_horiz_outlined,
            color: bg,
          )
        ],
      ),
      key: _scaffoldKey,
      body: Container(
        child: Observer(
          builder: (context) {
            if (store.isMainComicLoading) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Lottie.asset('assets/loading.json',
                    height: 120, width: 120),
              );
            } else {
              return Container(
                color: bg,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: '#',
                                    style: headingId.copyWith(fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${store.comic.getComicNumber}",
                                          style: headingId)
                                    ]),
                              ),
                              Text(
                                "${formatter.format(DateTime.parse(store.comic.getComicDate))}",
                                overflow: TextOverflow.ellipsis,
                                style: date,
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              store.getRandomComic();
                            },
                            color: white80,
                            icon: Icon(
                              FeatherIcons.refreshCcw,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.30,
                    //       child: Row(
                    //         children: [
                    //           IconButton(
                    //             icon: Icon(
                    //               Icons.favorite,
                    //               color: store.isComicFavorite
                    //                   ? Colors.red
                    //                   : Colors.white,
                    //               size: 25.0,
                    //             ),
                    //             onPressed: () {
                    //               store.addFavComic();
                    //             },
                    //           ),
                    //           IconButton(
                    //             icon: Icon(
                    //               Icons.share_rounded,
                    //               color: Colors.white,
                    //               size: 25.0,
                    //             ),
                    //             onPressed: () async {
                    //               await store.shareImage();
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.30,
                    //       child: Column(
                    //         children: [
                    //           Text(
                    //             "#${store.comic.getComicNumber}",
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               fontSize: 20.0,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w300,
                    //             ),
                    //           ),
                    //           Text(
                    //             "${formatter.format(DateTime.parse(store.comic.getComicDate))}",
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               fontSize: 14.0,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w200,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       alignment: Alignment.centerRight,
                    //       width: MediaQuery.of(context).size.width * 0.30,
                    //       child: IconButton(
                    //         icon: Icon(
                    //           Icons.download_rounded,
                    //           color: Colors.white,
                    //           size: 25.0,
                    //         ),
                    //         onPressed: () async {
                    //           store.downloadImage();
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "${store.comic.getComicTitle}",
                style: headingText,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              height: MediaQuery.of(context).size.height * 0.38,
              child: Card(
                child: InteractiveViewer(
                  maxScale: 2.5,
                  child: CachedNetworkImage(
                    imageUrl: "${store.comic.getComicUrl}",
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "${store.comic.getComicAlt}",
                textAlign: TextAlign.justify,
                style: caption,
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(FeatherIcons.share2),
                  color: Colors.white,
                  onPressed: () async {
                    await store.shareImage();
                  },
                ),
                IconButton(
                                icon: store.isComicFavorite
                                    ? Icon(
                                        Icons.favorite,
                                        color: red,
                                      )
                                    : Icon(
                                        FeatherIcons.heart,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                     store.addFavComic();
                                  },),
                IconButton(
                  icon: Icon(FeatherIcons.download),
                  color: Colors.white,
                  onPressed: () async {
                    await store.downloadImage();
                  },
                ),
              ],
            )
                    // Container(
                    //   // color: Colors.white,
                    //   height: MediaQuery.of(context).size.height * 0.09,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Center(
                    //             child: Text(
                    //           "${store.comic.getComicTitle}",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             fontSize: 28.0,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.w300,
                    //           ),
                    //         )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.03,
                    // ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.40,
                    //   child: Card(
                    //     child: InteractiveViewer(
                    //       maxScale: 2.5,
                    //       child: CachedNetworkImage(
                    //         imageUrl: "${store.comic.getComicUrl}",
                    //         fit: BoxFit.contain,
                    //         errorWidget: (context, url, error) =>
                    //             Icon(Icons.error),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    // ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.20,
                    //   padding: EdgeInsets.symmetric(horizontal: 25.0),
                    //   child: Center(
                    //     child: Text(
                    //       "${store.comic.getComicAlt}",
                    //       textAlign: TextAlign.justify,
                    //       style: TextStyle(
                    //         fontSize: 14.0,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w300,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
