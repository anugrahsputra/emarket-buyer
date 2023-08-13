# E-Market Project

This is a Flutter project developed as a thesis to fulfill the graduation requirements for a Bachelor's degree in Informatics Engineering at Universitas Pasundan (Pasundan University). There are two applications in this project, namely the [E-Market Seller application](https://github.com/anugrahsputra/emarket-seller.git) and the [E-Market Buyer application.](https://github.com/anugrahsputra/emarket-buyer.git)

## E-Market Buyer Application

<img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/7d6d2683-09bb-4ab6-b36f-006ee138bb23" alt="Image" style="border-radius:1%"/>

The E-Market Buyer mobile application is designed for buyers who want to purchase products online from the E-Market platform. This application caters to the needs of people residing in Kecamatan Malingping.

## Target Users: People in Kecamatan Malingping

The E-Market Buyer mobile application aims to provide a convenient platform for buyers in Kecamatan Malingping to browse and purchase products online. By focusing on this specific user group, the application takes into account the unique preferences and requirements of buyers in Kecamatan Malingping, offering tailored features and functionalities to enhance their shopping experience.

## Demo


## Screenshots
<p>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/7be54ba6-0f2d-44a4-8963-7c156e4e668e" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/020078dd-ac64-4f45-b78d-35d37b665183" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/0d7cc486-d34d-445a-aac3-9e96d4aa8253" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/f0cfc6ea-4529-45ae-8280-3aa328918b5f" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/f557d106-bab1-4f9e-9fb9-f785d5833884" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/f17b042b-ba3e-4826-a089-2638098ac273" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/18f69657-8533-4da9-bcea-270483b436d6" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/7d802ad4-5c11-420f-b15b-b6c25e364b49" alt="Image" width="250"/>
    <img src="https://github.com/anugrahsputra/emarket-buyer/assets/71306482/6701e84a-05f6-4b6a-8a35-5049a00ba6b8" alt="Image" width="250"/>
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

```
git clone https://github.com/anugrahsputra/emarket-buyer.git
cd emarket-buyer
```

Get all the dependencies:

```
flutter pub get
```

### Notes 🗒️

- The E-Market Buyers application does not have payment gateway integration. This decision is based on the understanding that most UMKM businesses in Kecamatan Malingping do not have the resources to support online payment transactions. Instead, the application allows buyers to place orders and arrange payment and delivery details directly with the sellers.

- ##### All the technologies that are used in this project using the paid version. So, if you want to try this app, you need to create your own project in Firebase and Google Cloud Platform and replace the API keys with your own API keys
