//
//  scannerViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/15/21.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore
import SCSDKBitmojiKit
import AudioToolbox

class scannerViewController: UIViewController {
   
    let currentUserEmail = Auth.auth().currentUser!.email
    let db = Firestore.firestore()
    var cellData = [EventInfoDataModel]()
    var uidInfo = [UidDataModel]()
    
    @IBOutlet weak var collectionView:
        UICollectionView!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var video = AVCaptureVideoPreviewLayer()
   
    var codeOutput = "" //QR Code Outpu
    var eventID = "" //selected from table view // will be passed to the verification method
    var eventName = ""
    var finalOutput = ""
    
    var firstname = ""
    var lastname = ""
    var uid = ""
    var social = ""
    
    var didSelectAnEvent : Bool = false
    @IBOutlet weak var guestFoundButton: UIButton!
    
    let iconView = SCSDKBitmojiIconView()
  //scanner
    
    @IBOutlet weak var backButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.guestFoundButton.isEnabled = false
        
                
        
        loadData() //hehe works
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "buttonCell")
       
        
        
        //creating session
        let session = AVCaptureSession()

        //Define Capture
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // Do any additional setup after loading the view.
        
        do{
            
            let input = try AVCaptureDeviceInput(device: captureDevice!) //Idk if we need to force unwrap
            session.addInput(input) //defining input constant
        }
        catch {
        
            print("error from capturing device")
            
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        //Only QR Code Output
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
       
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(infoLabel)
        self.view.bringSubviewToFront(collectionView)
        self.view.bringSubviewToFront(nameLabel)
        self.view.bringSubviewToFront(iconView)
        
        session.startRunning() // starts the bullshit
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is verifiedViewController {
            let vc = segue.destination as? verifiedViewController
            vc?.firstname = firstname
            vc?.lastname = lastname
            vc?.uid = uid
            vc?.social = social
            
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        

        transitionToHome()
        
    }
    
    func transitionToHome (){
        //back button
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
       
        
    }
    @IBAction func guestFoundButtonTapped(_ sender: Any) {
        
        db.collection("users").document(self.currentUserEmail!).updateData(["clout" : FieldValue.increment(Int64(3))])
        self.view.sendSubviewToBack(self.guestFoundButton)
        self.guestFoundButton.isEnabled = false
        
    
    }
    
    func loadData() {
        //need this to work
        db.collection("users").document("\(currentUserEmail!)").collection("active_events").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else{
                self.cellData = querySnapshot!.documents.compactMap({EventInfoDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                self.collectionView.reloadData()
                    
            }
        }
      }
    }
    func setBlurView() {
          // Init a UIVisualEffectView which going to do the blur for us
          let blurView = UIVisualEffectView()
          // Make its frame equal the main view frame so that every pixel is under blurred
          blurView.frame = view.frame
          // Choose the style of the blur effect to regular.
          // You can choose dark, light, or extraLight if you wants
          blurView.effect = UIBlurEffect(style: .regular)
          // Now add the blur view to the main view
          view.addSubview(blurView)
      }
    
}
extension scannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects != nil && metadataObjects.count != 0 {
            //this warning is dumb
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                if object.type == AVMetadataObject.ObjectType.qr {
                    
                    self.codeOutput = object.stringValue!
                    
                    let codeItems : Array = codeOutput.components(separatedBy: "_")
                    
                    self.finalOutput = codeOutput
                    // Step. 3 this is sent to the final output variable to be dissected and send into various functions
                    //array
                    
                    //0 and 1 will be the output
                    
                    
                    
                    print("\(codeItems[0])")
                    
                    print("This will be dissected \(finalOutput)") //works
                    
                    //this is going to return an array to be seperated.
                    //now we have qr code
                   // let alert = UIAlertController(title: "Guest Found", message: object.stringValue, preferredStyle: .alert)
                  //  alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                   // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                   // present(alert, animated: true, completion: nil)
                    
                    self.verifyUser()
                }
            }
        }
    }
    
    func verifyUser () {
        //this is being scanned from the qr code and sent to the above function.
        let qrCodeItems = finalOutput.components(separatedBy: "_")
        
        
        if didSelectAnEvent == false {
            
            let alert = UIAlertController(title: "Please Select an Event Below", message: "Before you can scan your guest's tickets, select one of your previously created events.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
        } else {
        
        //separates the function and returns an array
        if qrCodeItems.count != 2 {
            
            print("this QR Code is invalid")
            
            let alert = UIAlertController(title: "Invalid QR Code", message: "Nice Try", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        else if qrCodeItems[1] == eventID {
            //continue the function //get documents of specified event // cross reference user ID's in the guest list
            db.collection("active_events").document("\(eventID)").collection("guest_list").whereField("uid", isEqualTo: "\(qrCodeItems[0])").getDocuments { (querySnapshot,error) in
                if let error = error {
                   print("\(error) the data failed to load")
                   
                    let alert = UIAlertController(title: "Invalid Guest", message: "It seems that this guest isn't on the guestlist, their ticket may be doctored", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
        
                } else {
                    for document in querySnapshot!.documents {
                                   //this all works
                                 print("\(document.documentID) => \(document.data())") //this retrieves data from specified document!
                        
                        
                        let data = document.data()
                        let firstname = data["firstname"] as! String
                        let lastname = data["lastname"] as! String //it'll be there.
                        let uid = data["uid"] as! String
                        let social = data["social"] as! String
                        
                        self.view.bringSubviewToFront(self.guestFoundButton)
                        self.guestFoundButton.isEnabled = true
                       
                                 
                        self.firstname = firstname
                        self.lastname = lastname
                        self.uid = uid
                        self.social = social
                   
                }
            }
        }
            
            
            
        } else if qrCodeItems[1] != eventID {
            //return alert that this is the wrong event or user needs to make sure right event is selected. //this is the event ID
            print("this is the wrong event or user needs to make sure right event is selected")
            
            let alert = UIAlertController(title: "Hmm...", message: "It seems that this guest isn't on the guest list. Make sure you've selected the right event", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    
        
    }
   
    
    
    //take array and cross reference it with data in the guest list documents

}
}

extension scannerViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! CollectionViewCell
       
        let data = cellData[indexPath.row]
        
        cell.eventLabel.text = "\(data.name)"
        //sets the label of the cell to particular name
        //cell.subView.layoutIfNeeded()
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! CollectionViewCell
       

        cell.subView.layer.borderWidth = 2
        cell.subView.layer.borderColor = UIColor.lightGray.cgColor
        
        let data = cellData[indexPath.row]
        
        eventID = data.docID
        eventName = data.name
        //passes the string of the eventID and
        
        
        self.nameLabel.text = "\(eventName)"
        self.didSelectAnEvent = true
        //sets the event ID to the name
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //cell.layer.cornerRadius = 30
          //  cell.clipsToBounds = true
    }
    
    
    
    
    
    
}


