# HackGTX
Our project for HackGT 2023

## Inspiration
We have all seen litter on the side of the road. It pollutes our environment and damages our quality of life. To encourage the city clean-up effort, we made an app that rewards users for picking up trash on their daily commutes and participating in community clean-up events.
## What it does
Our app allows a user to input a starting and ending location. From there, it calculates a path that optimizes both the shortest route and the least trash cans. This path will likely have the most trash. From there, users can submit photos of the trash they pick up to earn points. Additionally, users can create or participate in community events, which will cover longer distances and give more opportunities for points. Altogether, our app encourages users to clean the environment actively and fosters community engagement. 
## How we built it
Our front end is a Flutter app, and our back end is written in Python using Django. We set up a SQLite database to store user information and necessary files for app logic. We plan paths using the osmnx library with custom edge weights. In order to detect the amount of trash in a photo, we used the SSD MobileNet TensorFlow model for image segmentation. 
## Challenges we ran into
One challenge we faced was building features to minimize cheating. Our solution was to award community events and individual events separately in terms of points, as community events will hold users accountable for actually picking up trash. As a bonus, people who participate in community events, get bonuses when they do individual events so that people can be rewarded for the small acts they do as well.

A technical challenge we faced was integration. While we each had our own specialization, when it came time to merge the different features of the app together, there were issues with timing, data management, and compatibility. We ended up resolving these by diagramming our individual solutions and the ideal integration on our whiteboard. With an easy way to visualize our app, we were able to solve this challenge. 
## Accomplishments that we're proud of
We are proud of implementing an app that not only helps clean the environment but also emphasizes health by encouraging walking and building a stronger community more focused on its surroundings. In terms of technical accomplishments, we are also proud of creating a fast map application that is easy and intuitive to use. Additionally, we are proud to have been able to implement machine learning through our image segmentation model.
## What we learned
We each learned many new things as we ended up working together on the integration. We each picked up the other's respective skills in Django, Flutter, Python, and TensorFlow. We also learned how important it is to think about potential faults with your app. By predicting potential liabilities like cheating the system, we were able to develop countermeasures in our app, making the product more viable overall.
## What's next for EcoTrek
We will increase scalability by expanding our app to other major metro areas. Furthermore, we also plan to have a more structured database that allows for more user storage and more features like a leaderboard. We plan to enhance our machine learning software by training on more data to more accurately segment images. Finally, we want to partner with major companies that align with our conservationist values for potential rewards for our users.
