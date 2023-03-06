//
//  FLNativeViewFactory.swift
//  flutter_credit_card
//
//  Created by Ujas Majithiya on 07/03/23.
//

import Foundation
import Flutter
import SwiftUI

@available(iOS 13.0, *)
class FLNativeViewFactory: NSObject,FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

@available(iOS 13.0, *)
class FLNativeView: NSObject, FlutterPlatformView {
    @State private var isShowingSheet = true
    private var _view: UIView
    func view() -> UIView {
        child.loadView()
        return _view
    }
    
    //private var _view: UIView
   
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        createNativeView()
    }
    

    func createNativeView(){
        _view.addSubview(child.view)
    }

    var body: some View {
        ScrollView(.vertical){
            VStack {
                
            }.sheet(isPresented: $isShowingSheet) {
                CardReaderView() {card in
                    print(card ?? "it was nil")
                    self.isShowingSheet.toggle()
                }
            }
            
        }
        
    }
    
    var child : UIHostingController<some View> {
        return UIHostingController(rootView: body)
    }
}
