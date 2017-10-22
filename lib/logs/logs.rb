class Logs
  UUID = SecureRandom.uuid.to_s
  START_PROCESS =  UUID +  '===> Start %s ---' + Time.now.to_s
  FETCH_URL = UUID + '===> Fetch url--- Serial_Number/KKID: %s ---' + Time.now.to_s
  UPDATE_TABLE = UUID + '===> Update %s table %s ---' + Time.now.to_s
  SLEEP = UUID + '===> Completed Sleep %s second ---' + Time.now.to_s
  COMPLETED = UUID + '===> Completed %s ---' + Time.now.to_s
  PROCESS_FAILD = UUID + '===> Processing %s Error--- Serial_Number/KKID: %s ' + Time.now.to_s
  DOWNLOADING = UUID + '===> Downloading Image %s ---' + Time.now.to_s
end
