//
//  DownloadTask.swift
//  IntellectionLib
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

public class DownloadTask: NSObject,URLSessionDelegate
{
    var m_miliseconds:Double = 0
    var m_downLoadStartTime:UInt64 = 0
    var m_macAbsoluteEndTime:UInt64 = 0
    var m_downLoadEndTime:UInt64 = 0
    var m_totalBytesSent:Int64 = 0
    
//    var m_dataSpeedHolderArray = Array<DataSpeedHolderClass>()
    
    var m_downloadTask: URLSessionDownloadTask?
    public var delegate: DownloadTaskProtocol?
    var m_session:URLSession?
 
    var m_downloadUrlPath = String()
    
    public func stopDownload()
    {
        
        m_session?.finishTasksAndInvalidate()
        m_downloadTask?.cancel()
        m_downloadTask = nil
    }
    
    func getMachAbsoluteTime()->UInt64
    {
        return mach_absolute_time()
    }
    public func downloadFile(downloadPath:String)
    {
        
        if(m_downloadTask != nil)
        {
            stopDownload()
            return
        }
        m_session?.finishTasksAndInvalidate()
        
        let config = URLSessionConfiguration.background(withIdentifier: "Download")
        if let url = NSURL(string:downloadPath )
        {
            
            m_session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
            
            m_downLoadStartTime = getMachAbsoluteTime()
            
            m_downloadUrlPath = downloadPath
            
            m_downloadTask = m_session?.downloadTask(with: url as URL)
            if #available(iOS 11.0, *) {
                m_downloadTask?.countOfBytesClientExpectsToSend = Int64(32768.0)
            } else {
                // Fallback on earlier versions
            }
            m_downloadTask?.resume()
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        
        

        m_totalBytesSent = m_totalBytesSent + bytesWritten
        m_downLoadEndTime = getMachAbsoluteTime();
        if (totalBytesWritten == totalBytesExpectedToWrite)
        {
            m_macAbsoluteEndTime = getMachAbsoluteTime()
        }
        
        let uploadProgress:Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let progressPercent = Int(uploadProgress*100)
        let str = "Bytes transmitted: \(totalBytesWritten) downloaded:\(progressPercent)% \n"
        delegate?.downloadSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite, message: str, downloadProgress: uploadProgress, downloadPercent: progressPercent)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        let totalBytes = m_totalBytesSent
        var str = ""
        if (m_downLoadEndTime <= 0)
        {
            return
        }
        let totalDownloadElapsedTime = m_downLoadEndTime - m_downLoadStartTime
        let elapsedTimeInMiliSeconds = getMiliSecondsFromMachTime(elapsedTime: totalDownloadElapsedTime)
        
        let elapsedTimeInSec:Double = elapsedTimeInMiliSeconds/1000
        let downloadSpeedInMbps = calculateSpeedUsing(bytesSent: m_totalBytesSent, seconds: elapsedTimeInSec)
        
        let averageStr = String(format: "%.2f",downloadSpeedInMbps)
        
        str = "\nSummary:\nBytes transmitted: \(totalBytes) \nTime taken: \(getTimeTaken(time: elapsedTimeInMiliSeconds)) ms \nAvg. download speed: \(averageStr) "
        
     
        let downloadloadTest = DownloadTaskDetails()
        downloadloadTest.m_avgDownloadSpeed = downloadSpeedInMbps
        downloadloadTest.m_timeTaken = elapsedTimeInMiliSeconds
        downloadloadTest.m_bytesTransmitted = Double(totalBytes)
        downloadloadTest.m_downloadUrl = m_downloadUrlPath
        delegate?.downloadSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location, message: str, downloadTestDetails: downloadloadTest)
        
    
        stopDownload()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("error download \(String(describing: error?.localizedDescription))")
        if let msg = error?.localizedDescription
        {
            delegate?.downloadSession(session, task: task, didCompleteWithError: error, message: msg)
        }
        else
        {
            delegate?.downloadSession(session, task: task, didCompleteWithError: error, message: "")
        }
        
    }
    
    func appendText(_ msg: String)
    {
        print(msg)
    }
    
    func appendTextInline(_ msg: String)
    {
        print(msg)
    }
    
    func startMachTimer()
    {
        m_miliseconds = 0;
        
    }
    
   
   
    public func removeFile(location:URL)
    {
        
        do {
            try FileManager.default.removeItem(at: location)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        
        
    }
    func getAverage(totalBytes:Int64, time:TimeInterval)->String
    {
        let seconds:Double = Double(time/1000)
        
        let speed =  calculateSpeedUsing(bytesSent: totalBytes, seconds: seconds)
        print("speed: \(speed)")
        return String(format: "%.2f",speed)
        
        
    }
   
    func getTimeTaken(time:TimeInterval)->String
    {
        
        return String(format: "%.2f", time)
    }
    
    
}
public protocol DownloadTaskProtocol
{
    func downloadSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?, message:String)
    
    func downloadSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64, message:String,downloadProgress:Float,downloadPercent:Int)
    
    func downloadSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL, message:String, downloadTestDetails:DownloadTaskDetails)
}
public class DownloadTaskDetails
{
    var m_downloadUrl:String?
    var m_bytesTransmitted:Double?
    var m_timeTaken:Double?
    var m_avgDownloadSpeed:Double?
    var m_downloadUrlArray:Array<String>?
}

