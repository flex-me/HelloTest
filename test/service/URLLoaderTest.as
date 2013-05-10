package service
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flexunit.framework.Assert;
	
	import mx.controls.Alert;
	
	import org.flexunit.async.Async;

	public class URLLoaderTest
	{
		[Test(async)]
		public function testURLLoader():void{
			var loader:URLLoader = new URLLoader();
			var asyncHandler:Function = Async.asyncHandler( this, onComplete, 1500, null, onTimeout );
			loader.addEventListener(Event.COMPLETE, asyncHandler);
			loader.load(new URLRequest("http://www.baidu.com"));
		}
		
		protected function onComplete(event:Event, passThroughData:Object):void{
			trace("[Result Length]\t" + event.target.data.toString().length);
			trace("[Result Content]\t" + event.target.data.toString());
			Assert.assertTrue(event.target.data.toString().length > 30000);
		}
		
		protected function onTimeout(passThroughData:Object):void{
			Assert.fail("Should not timeout. ");
		}
	}
}