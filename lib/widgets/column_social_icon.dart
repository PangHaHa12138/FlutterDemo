import 'package:flutter/material.dart';
import 'package:test001/theme/colors.dart';

Widget getAlbum(albumImg) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
          // shape: BoxShape.circle,
          // color: black
          ),
      child: Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: black),
          ),
          Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          albumImg),
                      fit: BoxFit.cover)),
            ),
          )
        ],
      ),
    );
  }

  Widget getIcons(icon, count, size) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(icon, color: white, size: size),
          const SizedBox(
            height: 5,
          ),
          Text(
            count,
            style: const TextStyle(
                color: white, fontSize: 12, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget getProfile(img) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: white),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        img),
                    fit: BoxFit.cover)),
          ),
          Positioned(
              bottom: 3,
              left: 18,
              child: Container(
                width: 20,
                height: 20,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: primary),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: white,
                  size: 15,
                )),
              ))
        ],
      ),
    );
  }