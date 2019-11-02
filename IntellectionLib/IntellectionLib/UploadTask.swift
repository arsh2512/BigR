//
//  UploadTask.swift
//  IntellectionLib
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

public class UploadTask: NSObject,URLSessionTaskDelegate
{
    
    public var delegate : UploadTestRunnerProtocol?
    var m_uploadTask: URLSessionDataTask?
    var m_totalBytesTosend:Int64?
    var m_latency:TimeInterval?
    var m_avgSpeed = Double()
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func stopUpload()
    {
        m_uploadTask?.cancel()
        m_uploadTask = nil
    }
    func getTotalBytes()->String
    {
        if let totalBytes = m_totalBytesTosend
        {
            return "\(totalBytes)"
        }
        return "0"
    }
    func getAverage(timetaken: Double)->String
    {
        let avgResultString = "Very high (Infinite)"
        if let totalBytes = m_totalBytesTosend
        {
            let zeroTolerance = 1e-4;
            
            if(fabs(m_miliseconds - 0) < zeroTolerance)
            {
                
            }
            else
            {
                let seconds:Double = Double(m_miliseconds/1000)
                let speed = calculateSpeedUsing(bytesSent: totalBytes, seconds: seconds)
                
                m_avgSpeed = speed
                
            }
            
            return avgResultString
        }
        
        return "0.00"
    }
    func getLatency()->String
    {
        if let first = m_latency
        {
            return String(format: "%.2f", first)
        }
        return "0.00"
    }
    
    func getTimeTaken(time:TimeInterval)->String
    {
        return String(format: "%.2f", m_miliseconds)
    }
    
    public func uploadFile(data: Data, url:String,fileName:String,fileType:String)
    {
        
        if(m_uploadTask != nil)
        {
            stopUpload()
        }
        else
        {
            guard let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)  else {
                print("Error: cannot create uploadURL")
                return
            }
            guard let uploadURL = URL(string: escapedUrl) else {
                print("Error: cannot create uploadURL")
                return
            }
            
            let request = NSMutableURLRequest(url: uploadURL)
            request.httpMethod = "POST"
            
            let boundary = generateBoundaryString()
            
            print(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file))
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("hi\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(fileType)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            
            let configuration = URLSessionConfiguration.default
            
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
            
            startTimer()
            m_uploadTask = session.dataTask(with: request as URLRequest, completionHandler: {
                (
                data, response, error) in
                if (error != nil)
                {
                    //print( "error \(error?.localizedDescription)")
                    
                    
                }
                
                guard ((data) != nil), let _:URLResponse = response, error == nil else
                {
                    print("error upload")
                    if let errorDescription = error?.localizedDescription
                    {
                        if(errorDescription == "cancelled")
                        {
                            self.delegate?.uploadDidTerminiatedbyUser()
                        }
                        else
                        {
                            self.delegate?.uploadSession(session, didBecomeInvalidWithError: error, message: "\(errorDescription)\n")
                        }
                        
                    }
                    else
                    {
                        self.delegate?.uploadSession(session, didBecomeInvalidWithError: error, message: "Something went wrong")
                    }
                    self.stopUpload()
                    return
                }
                
                
                if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                {
                    print("dataString \(dataString)")
                    
                    let averageStr = self.getAverage(timetaken: self.m_miliseconds)
                    
                    let msg = "\nSummary:\nBytes transmitted: \(self.getTotalBytes()) \nTime taken: \(self.getTimeTaken(time: self.m_miliseconds)) ms  \nAvg. upload speed: \(averageStr) \nLatency: \(self.getLatency()) ms"
                    print("upload finished \(msg)")
                    
                    
                    let uploadTask = UploadTaskDetails()
                    uploadTask.m_avgUploadSpeed = self.m_avgSpeed
                    uploadTask.m_latency = self.m_latency!
                    uploadTask.m_timeTaken = self.m_miliseconds
                    uploadTask.m_bytesTransmitted = Double(self.m_totalBytesSent)
                    uploadTask.m_uploadUrl = uploadURL.absoluteString
                    
                    self.delegate?.didFinishedUploading(message: msg,uploadTaskDetails: uploadTask)
                    
                }
                else
                {
                    print("else executed")
                }
                
            })
            
            m_uploadTask?.resume()
        }
        
        
        
        
        
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        print("didCompleteWithError \(String(describing: error))")
    }
    var m_macAbsoluteStartTime:UInt64 = 0
    func startTimer()
    {
        m_miliseconds = 0;
        m_macAbsoluteStartTime = getMachAbsoluteTime()//mach_absolute_time()
        
    }
    func stopTimer()
    {
        
        m_miliseconds = getMachAboluteTimeDifference(machAbsoluteStartTime: m_macAbsoluteStartTime)
        
        print("total timer m_miliseconds = \(m_miliseconds)")
        
        
        
    }
    
    @objc func updateTimeMiliseconds()
    {
        m_miliseconds = m_miliseconds+1
    }
    
    var m_tempCounter = 1
    var m_miliseconds:Double = 0
    
    
    var m_totalBytesSent:Int64 = 0
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        
//        let dataSpeedHolder = DataSpeedHolderClass()
//        dataSpeedHolder.m_chunkOfbytesSent = bytesSent
//        dataSpeedHolder.m_durationToSendBytes = m_miliseconds
//
        m_totalBytesSent = m_totalBytesSent + bytesSent
        
        m_tempCounter = m_tempCounter+1
        
        
        if (totalBytesSent == totalBytesExpectedToSend)
        {
            self.stopTimer()
        }
        if(m_totalBytesTosend == nil)
        {
            m_totalBytesTosend = totalBytesExpectedToSend
            let macAbsoluteEndTime = mach_absolute_time()
            
            let elapsed = macAbsoluteEndTime-m_macAbsoluteStartTime
            var timeBaseInfo = mach_timebase_info_data_t()
            mach_timebase_info(&timeBaseInfo)
            let elapsedNano = elapsed * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom);
            m_latency = Double(elapsedNano/1000000)
        }
        
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let progressPercent = Int(uploadProgress*100)
        let str = "Total bytes transmitted = \(totalBytesSent) uploaded:\(progressPercent)% \n"
        delegate?.uploadSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend, message: str, uploadProgress: uploadProgress, uploadPercent:progressPercent)
    }
    
    
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError ")
        var msg = "Finished Without Error"
        if (error != nil)
        {
            msg = "Finished with error: \(String(describing: error?.localizedDescription))"
            print("error: \(error?.localizedDescription ?? "222") ")
        }
        delegate?.uploadSession(session, didBecomeInvalidWithError: error, message: msg)
    }
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("finished")
    }
    
    
    func getMachAbsoluteTime()->UInt64
    {
        return mach_absolute_time()
    }
    func getMachAboluteTimeDifference(machAbsoluteStartTime:UInt64)->Double
    {
        let macAbsoluteEndTime = mach_absolute_time()
        
        let elapsed = macAbsoluteEndTime-machAbsoluteStartTime
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let elapsedNano = elapsed * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom);
        
        return Double(elapsedNano/1000000)
    }
}
public protocol UploadTestRunnerProtocol
{
    func uploadSession(_ session: URLSession, didBecomeInvalidWithError error: Error?, message:String)
    
    func uploadSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64, message:String,uploadProgress:Float,uploadPercent:Int)
    
    func didFinishedUploading(message:String, uploadTaskDetails:UploadTaskDetails)
    
    func uploadDidTerminiatedbyUser()
}/*
class DataSpeedHolderClass
{
    var m_chunkOfbytesSent:Int64?
    var m_durationToSendBytes:Double?
    var m_chunkEndTime:UInt64?
}*/
public class UploadTaskDetails
{
    var m_uploadUrl:String?
    var m_bytesTransmitted:Double?
    var m_timeTaken:Double?
    var m_avgUploadSpeed:Double?
    var m_latency:Double?
    
}

