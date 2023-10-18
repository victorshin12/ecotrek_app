# EcoTrek

## Inspiration
We have all seen litter on the side of the road. It pollutes our environment and damages our quality of life. To encourage the city clean-up effort, we made an app that rewards users for picking up trash on their daily commutes and participating in community clean-up events.
## What it does
Our app allows a user to input a starting and ending location. From there, it calculates a path that optimizes both the shortest route and the least trash cans. This path will likely have the most trash. From there, users can submit photos of the trash they pick up to earn points. Additionally, users can create or participate in community events, which will cover longer distances and give more opportunities for points. Altogether, our app encourages users to clean the environment actively and fosters community engagement. 
## How we built it
Our front end is a Flutter app, and our back end is written in Python using Django. We set up a SQLite database to store user information and necessary files for app logic. We plan paths using the osmnx library with custom edge weights. In order to detect the amount of trash in a photo, we used the SSD MobileNet TensorFlow model for image segmentation. 
## What's next for EcoTrek
We will increase scalability by expanding our app to other major metro areas. Furthermore, we also plan to have a more structured database that allows for more user storage and more features like a leaderboard. We plan to enhance our machine learning software by training on more data to more accurately segment images. Finally, we want to partner with major companies that align with our conservationist values for potential rewards for our users.
