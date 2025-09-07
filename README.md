# 🍳 Ne Yesem

## 📜 About
**Ne Yesem**  is a modern mobile application that allows users to discover recipes, save favorites, and get ingredient-based suggestions based on what they already have at home. Users can search by dish type, manage their pantry easily, and enjoy a clean SwiftUI-based interface. The app is built with Firebase Authentication, Firestore, and MVVM architecture.

## 🚀 Features
✅ **Search by Dish Type** – Find recipes by categories such as breakfast, dessert, or main dish

✅ **Ingredient-Based Suggestions** – Get recipe recommendations using ingredients you already have

✅ **Fridge & Pantry Management** – Keep track of ingredients at home

✅ **Favorites** – Save your favorite recipes and revisit them anytime

✅ **Firebase Authentication** – Secure login with email or Google

✅ **SwiftUI & UIKit UI** – Smooth, modern, and user-friendly interface

✅ **Firestore Integration** – Sync and store user data (recipes, favorites, pantry items) in the cloud

## ⚙️ Technologies Used

- **Swift (iOS) → SwiftUI, UIKit, SnapKit**

- **Architecture → MVVM (clean & scalable code)**

- **Firebase Authentication → Secure login with email, Facebook or Google**

- **Firebase Firestore → Cloud-based real-time database for recipes, favorites, and pantry management**

- **Spoonacular API → Recipe search and ingredient-based suggestions**

## 📂 Project Structure

<pre>
📦 NeYesem
 ┣ 📂 Extensions          # Helpers & Swift extensions
 ┣ 📂 Resources           # Assets, Colors, Fonts
 ┣ 📂 Services            # Firebase, Firestore & API services
 ┣ 📂 Models              # Data models (Recipe, Ingredient, User, etc.)
 ┣ 📂 ViewModels          # MVVM ViewModels (business logic & data handling)
 ┗ 📂 Views
    ┣ 📂 TabBarController # Custom tab bar and navigation
    ┣ 📂 ViewControllers  # Screens (Meal, Favorites, Fridge, etc.)
    ┣ 📂 Views            # Reusable UI components
    ┗ 📂 Cells            # Custom collection/table view cells
</pre>

## 📂 Firestore Structure

<pre>
firestore-root
 ┣ favorites (collection)
 ┃  ┗ [recipeId] (document)
 ┃     ┣ dishTypes [array<string>]
 ┃     ┣ likeCount (number)
 ┃     ┣ readyInMinutes (number)
 ┃     ┣ recipeId (number)
 ┃     ┣ title (string)
 ┃     ┗ updatedAt (timestamp)
 ┃
 ┗ users (collection)
    ┗ [userId] (document)
       ┣ createdAt (timestamp)
       ┣ email (string)
       ┣ lastLogin (timestamp)
       ┣ name (string)
       ┣ surname (string)
       ┣ phone (string)
       ┣ photoURL (string)
       ┣ preferences (map)
       ┃  ┣ allergies [array<string>]
       ┃  ┣ diet (string)
       ┃  ┗ dislikes [array<string>]
       ┃
       ┣ favorites (subcollection)
       ┃  ┗ [recipeId] (document)
       ┃     ┣ calories (number)
       ┃     ┣ colorHex (string)
       ┃     ┣ createdAt (timestamp)
       ┃     ┣ dishTypes [array<string>]
       ┃     ┣ readyInMinutes (number)
       ┃     ┣ recipeId (number)
       ┃     ┗ title (string)
       ┃
       ┣ fridges (subcollection)
       ┃  ┗ [fridgeItemId] (document)
       ┃     ┣ aisle (string)
       ┃     ┣ amount (number)
       ┃     ┣ name (string)
       ┃     ┗ unit (string)
       ┃
       ┣ recentViews (subcollection)
       ┃  ┗ [recipeId] (document)
       ┃     ┣ dishTypes [array<string>]
       ┃     ┣ readyInMinutes (number)
       ┃     ┣ recipeId (number)
       ┃     ┣ title (string)
       ┃     ┗ viewedAt (timestamp)
       ┃
       ┗ shoppingLists (subcollection)
          ┗ [listId] (document)
             ┣ id (string/uuid)
             ┣ title (string)
             ┣ createdDate (timestamp)
             ┗ items [array<map>]
                ┣ id (string/uuid)
                ┣ name (string)
                ┣ category (string)
                ┗ isCompleted (bool)
</pre>

## 📸 Screenshots
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 32 51" src="https://github.com/user-attachments/assets/429d3ec9-6fae-4664-9030-a2ec7d6dedf6" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 33 05" src="https://github.com/user-attachments/assets/b1baa1aa-b6ca-4767-9ad9-0325ceeffbed" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 36 13" src="https://github.com/user-attachments/assets/51e926ce-a2cb-4543-8044-176d10210b51" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 36 22" src="https://github.com/user-attachments/assets/5b049201-495a-49b7-b6f7-29b1aa8398f8" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 36 28" src="https://github.com/user-attachments/assets/9f23a47e-6b32-4524-be00-2762794c2f10" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 36 36" src="https://github.com/user-attachments/assets/1c815c40-db62-4621-ad43-2092c526c44d" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 36 48" src="https://github.com/user-attachments/assets/149997be-cc47-4d80-a42b-6ab3372f6f87" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 01" src="https://github.com/user-attachments/assets/9cfbcf34-03bb-4819-be12-71c945cf1eb1" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 22" src="https://github.com/user-attachments/assets/f894880e-751d-4c14-9f13-94985600422a" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 28" src="https://github.com/user-attachments/assets/95f5fcdd-6b36-47b9-a29a-cf7cdd79301f" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 36" src="https://github.com/user-attachments/assets/161497a0-cb6c-4acb-94f3-99b5cee707b1" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 53" src="https://github.com/user-attachments/assets/0056989f-3002-4cdd-b393-bc92d063fb7c" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 37 44" src="https://github.com/user-attachments/assets/be866cd3-cbd1-4d95-b6f5-257ae15752f7" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 38 06" src="https://github.com/user-attachments/assets/9758d80e-efe0-44d4-89c3-ddcce6b23669" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 48 34" src="https://github.com/user-attachments/assets/629dfe62-5b36-4642-a86b-1f35f6cfd069" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 38 32" src="https://github.com/user-attachments/assets/15c04d2a-073e-4672-a195-3d364809821f" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 39 12" src="https://github.com/user-attachments/assets/943cc743-9df9-4520-8d1b-4845ed11c45e" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 56" src="https://github.com/user-attachments/assets/98ec3b10-564e-4ff8-9209-b5e178d8b2ce" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 49" src="https://github.com/user-attachments/assets/82995459-dfe2-416f-8524-ba56f5a948d0" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 46" src="https://github.com/user-attachments/assets/ddb09609-f5e2-4496-a0ba-128c79eb4e21" /> 
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 57 55" src="https://github.com/user-attachments/assets/e32b15c7-95d6-4bda-b42e-6012fa9e5439" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 39 15" src="https://github.com/user-attachments/assets/cff4f93c-a166-4699-aa98-6a7170a30288" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 39 50" src="https://github.com/user-attachments/assets/6778a640-21cb-4445-a6bc-45261fa23f7e" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 33" src="https://github.com/user-attachments/assets/080270bc-969f-4bbf-9384-8a74119c9253" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 14" src="https://github.com/user-attachments/assets/8420cba8-9c16-4e67-a8a1-9e274e55944a" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 16 40 28" src="https://github.com/user-attachments/assets/bf9577f2-840d-49df-b854-45196bde9ed0" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 17 14 22" src="https://github.com/user-attachments/assets/b61b5d5f-d32e-4306-b2de-70cb88323cec" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 17 14 33" src="https://github.com/user-attachments/assets/6d6733f1-d994-46b9-af82-c47f9b3c4564" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-09-07 at 17 15 40" src="https://github.com/user-attachments/assets/75d6951d-fa49-4982-a23b-8eec7b8feb84" />
