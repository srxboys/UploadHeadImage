# UploadHeadImage
##实时更新头像
--------
* 过程描述：   
  * 先判断 头像地址是否有文件。      
  * 有文件，就返回本地路径。      
  * 没有文件，就请求数据。      
* 下载成功、下载失败。       
  * 以block的形式 返回 
  
------
##下载成功
###判断下载NSData 是否和 缓存的NSData 一样
   *  一样 && 下载的NSData==image的处理
      * 不做write的操作，也就是不替换原来的文件
   * 不一样 && 下载的NSData==image的处理
      * 执行write的操作，把下载NSData  write 替换原来的文件
   * 其他条件，说明 NSData下载的就不是 图片(image)文件
      * 不做处理    
        
![image](https://raw.githubusercontent.com/srxboys/UploadHeadImage/master/updateLoadHeadImg.gif)
