# Transports Project

This project displays different transport options in a map, given a City name and its coordinates.

## ****Installation****

This project uses [SPM](https://swift.org/package-manager/) as a dependency manager.
To run it
    Open MeepTest.xcodeproj with Xcode
    Select MeepTest target 
    Select the desired Simulator
    Run

To test it
    Select MeepTest target
    Select Test in the dropdown menu in Xcode
    Test
    
### ***Requirements***

``iOS 12.0 or higher``
``Swift 5.2``

## ****Structure****

This project is structured trying to follow an hexagonal architecture.

                        Infrastructure - Application - Domain
                        
### **Infrastructure**

This layer contains all the project configuration plus implementations of third party providers in order to decouple it from our domain.

For instance, the APIClient provider implementation is made under this layer. By this approach, we are decoupling our Network Layer from the Application and we could use an in-house development or a third party one.

Here it can be found:

***Mappers*** 
***Configuration***
***APIClient***
***CompanyZoneProviders***

### **Application**

This layer contains all the iOS Platform specific implementation. We can find the UI scenes and usecases needed to provide information.

***UI*** 
            MapViewScene
            DetailScene
***Use Cases***

#### *UI Architecture*
For UI we've decided to use a Clean MVVM + C (Model-View-ViewModel + Coordinator) pattern. 

****View**** - represents the data to the user and responds to user interaction
****Model**** - represents the data object needed to represent data in the view
****ViewModel**** - represents the link to the user interaction and the domain data

****Coordinator**** - represents the navigation through Scenes.
    ***SceneDelegate*** - represents the actions handled by the scene in order to navigate

### **Domain**

This layer contains the core of the project. It defines the basic needs and shared resources through the Application Layer. 

***Mappers***
***Client***
***Repository***
***Model***

---Considerations--- Domain is depending on RxSwift. 

## ****Dependencies****

[RxSwift](https://github.com/ReactiveX/RxSwift)
    Handles the threading in the system. It also allows us to combine different streams and functions under a declarative way.
[Moya](https://github.com/Moya/Moya)
    Network abstraction layer to provide endpoints configurations, request performer and parser. It uses Alamofire under the hood.
[Quick/Nimble](https://github.com/Quick/Quick)
    Testing helper framework to help with test writing, providing a more sugar syntax.
    

#### **Next Steps**

Further development is needed.
- There is still a room for improvement in the data modeling and parsing. Right now we're just considering a transport using common resources, but we would need to consider all the different kind of transport providers (bus, train, bikes...) to map them to a known object.
- Under the MapKit there is still some job needed to be done. We could extract all the MapKit specific implementations to an Adapter to handle the Annotations Data Source. Also a best approach of PinView should be developed to avoid doing that logic in the ViewController.
- Change Transport Model dependency in both scenes in order to decouple them. We would need to have a specific DTO for each scene (p.s MapTransport and DetailTransport) and let each transport provider manage the color or detail information.
- Adding Snapshot testing to each View.
- Adding UITest (E2E). This would make us implement the "fake" data provided by the Moya framework to avoid calling the endpoint in order to improve test speed.
- Extract to modules (Packages) Domain, APIClient and even each scene implementation, in order to bound their context.
