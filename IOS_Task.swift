import UIKit
import MapKit
import CoreLocationclass 
FifthScreen: UIViewController, UITextFieldDelegate {    
@IBOutlet weak var mv1: MKMapView!   
@IBOutlet weak var sc1: UISegmentedControl!           
@IBOutlet weak var tf1: UITextField!        
@IBOutlet weak var label1: UILabel!    
@IBOutlet weak var button1: UIButton!    
@IBOutlet weak var button2: UIButton!        
@IBOutlet weak var label2: UILabel!            
@IBOutlet weak var bar: UIBarButtonItem!
override func viewDidLoad() {        
super.viewDidLoad()        
self.title = "Static Location"        
// Do any additional setup after loading the view.               
tf1.delegate = self    }
@IBAction func sc1Click() {        
let x : Int = sc1.selectedSegmentIndex                
if x == 0{            
mv1.mapType = .standard 
 }        
else if x == 1{            
mv1.mapType = .satellite        
}       
 else {           
 mv1.mapType = .hybrid        
}
}        
@IBAction func barClick(_ sender: Any) {        self.navigationController?.popToRootViewController(animated: true)    }    
@IBAction func button1Click() {let session1 = URLSession.shared        
 //let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Bengaluru,IN?&APPID=f31356634fbc4c64c86edd02aaf817c2")!               
let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(tf1.text!)?&APPID=f31356634fbc4c64c86edd02aaf817c2")! 
print("weatherURL:\n\(weatherURL)")        
let task1 = session1.dataTask(with: weatherURL){            
(data: Data?, response: URLResponse?, error: Error?) in            
if let error1 = error{                  
print("Error:\n\(error1)")            
}            
else{  if let data1 = data{ //   print("Bytes Data:\n\(data1)")                                      
// coverting bytes to String                                       
let dataString = String(data: data1, encoding: String.Encoding.utf8)                      
// print("All the weather data:\n\(dataString!)")
 if let firstDictionary = try? JSONSerialization.jsonObject(with: data1, options: .allowFragments) as? NSDictionary{                     //   print("first Dictionary values: \(firstDictionary)")                                                   
if let secondDictionary = firstDictionary.value(forKey: "main") as? NSDictionary{                                                      //  print("main Dictionary values are: \(secondDictionary)")                                                                        
  // to display temperature
if let temperaturevalue = secondDictionary.value(forKey: "temp") {                                
DispatchQueue.main.async {                                      
print("\(self.tf1.text!): \(temperaturevalue)°F")                                   
self.label1.text = "\(self.tf1.text!) Temperature: \(temperaturevalue)°F"                         
 } }}                        
else { print("Error: unable to find temperature in dictionary") } }
else {  print("Error: unable to convert json data") }}                
else { print("Error: did not receive data") } } }        
task1.resume()}
@IBAction func button2Click() {        
let address = tf1.text             
CLGeocoder().geocodeAddressString(address!, completionHandler: { placemarks, error in                 
if(error != nil){return}                 
if let placemark1 = placemarks?[0]{                     
let lat = String(format : "%.04f",(placemark1.location?.coordinate.latitude ?? 0.0)!)                    
let lon = String(format : "%.04f",(placemark1.location?.coordinate.longitude ?? 0.0)!)                                                               self.label2.text = "latitude:\(lat) and longitude: \(lon)"                                         
let staticlocation = CLLocationCoordinate2D(latitude: Double.init(lat) ?? 0.0, longitude: Double.init(lon) ?? 0.0)                     //                     let staticlocation = CLLocationCoordinate2D(                           )                                          
let span1 = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)                                                          let region1 = MKCoordinateRegion(center: staticlocation, span: span1)                                                           self.mv1.setRegion(region1, animated: true)                                        
let annotation = MKPointAnnotation()                    
annotation.coordinate = staticlocation                     annotation.title = self.tf1.text
self.mv1.addAnnotation(annotation) }})}        
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
tf1.resignFirstResponder()    }        
func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
textField.resignFirstResponder()        return true        
}           
 }
