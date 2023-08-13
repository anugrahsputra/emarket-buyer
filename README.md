# E-Market Project

This is a Flutter project developed as a thesis to fulfill the graduation requirements for a Bachelor's degree in Informatics Engineering at Universitas Pasundan (Pasundan University). There are two applications in this project, namely the [E-Market Seller application](https://github.com/anugrahsputra/emarket-seller.git) and the [E-Market Buyer application.](https://github.com/anugrahsputra/emarket-buyer.git)

## E-Market Buyer Application
<img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/9e868995-9b48-4819-a1df-befc67e338e3" alt="Image" style="border-radius:1%"/>

The E-Market Buyer mobile application is designed for buyers who want to purchase products online from the E-Market platform. This application caters to the needs of people residing in Kecamatan Malingping.

## Target Users: People in Kecamatan Malingping

The E-Market Buyer mobile application aims to provide a convenient platform for buyers in Kecamatan Malingping to browse and purchase products online. By focusing on this specific user group, the application takes into account the unique preferences and requirements of buyers in Kecamatan Malingping, offering tailored features and functionalities to enhance their shopping experience.

## Demo

<img src="assets/screenshot/emarket-buyer.gif" alt="screenrecord" width="320">

## Screenshots
<p>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/1dae3a49-8072-4737-b575-a00337cfdb41" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/d70150fb-81f1-4cba-9ced-2715b76b1c6a" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/51a651db-ff09-48e9-8d43-82a7653bc941" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/6ddbe9de-3fae-40ef-a662-40cc5d39673f" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/261393a6-85bb-4f78-a303-cf26cfc03b5f" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/0cc7d7a0-523b-46dd-addc-390d16807775" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/d8da1f35-f121-4d98-86e7-22322af4dfd7" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/b31e4281-df02-4f89-a7d8-05b333379b07" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/3d35c3a2-4c24-4060-b422-4846172919dc" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/f5abd324-c7b1-489d-972a-9fa5565012f3" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/3146be69-bc33-4d01-a2b5-b1ff9f097084" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/db0b01dc-df85-4cf4-af28-66ec39ef3177" alt="Image" width="250"/>
</p>

## Features

- Authentication
  - [x] Login
  - [x] Register
  - [ ] Forgot Password
  - [ ] Email Verification
  - [ ] Phone Verification
- Browse Available Products
  - [x] List view
  - [x] Grid view
  - [x] Filter products by categories
  - [x] Search Products
  - [x] Detail Products
  - [x] Add Product to cart
- Purchasing Products
  - [x] Checkout Information Detail
  - [x] Order History
  - [x] Delivery Tracking
- Product Details
  - [x] Product Information
  - [x] Product Star Reviews
  - [x] Product Comments

## Technologies

- [Firebase](https://firebase.google.com/)
  - [Authentication](https://firebase.google.com/docs/auth)
  - [Cloud Firestore](https://firebase.google.com/docs/firestore)
  - [Cloud Storage](https://firebase.google.com/docs/storage)
  - [Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)

- [Google Maps](https://developers.google.com/maps/documentation)
  - [Geocoding API](https://developers.google.com/maps/documentation/geocoding/overview)
  - [Places API](https://developers.google.com/maps/documentation/places/web-service/overview)
  - [Maps SDK for Android](https://developers.google.com/maps/documentation/android-sdk/overview)
  - [Directions API](https://developers.google.com/maps/documentation/directions/overview)
  - [Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/overview)

- [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
  - [GetX](https://pub.dev/packages/get)

## Packages

You can see the packages used in this project inside the file [pubspec.yaml](pubspec.yaml).

## Installation and Usage

To try the app, you can clone this repository and run it on your local machine:

```bash
git clone https://github.com/anugrahsputra/emarket-buyer.git
cd emarket-buyer
```

Get all the dependencies:

```bash
dart pub get
```

### Notes 🗒️

- The E-Market Buyers application does not have payment gateway integration. This decision is based on the understanding that most UMKM businesses in Kecamatan Malingping do not have the resources to support online payment transactions. Instead, the application allows buyers to place orders and arrange payment and delivery details directly with the sellers.

- ##### All the technologies that are used in this project using the paid version. So, if you want to try this app, you need to create your own project in Firebase and Google Cloud Platform and replace the API keys with your own API keys
