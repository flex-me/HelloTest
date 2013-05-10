package ui
{
	import flash.events.Event;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	public class TextInputTest
	{		
		private var textInput:TextInput;
		
		[Before(async, ui)]
		public function setUp():void {
			textInput = new TextInput();
			//这里的1000毫秒是指方法UIImpersonator.addChild( textInput )执行之后，如果1000毫秒内未抛出
			//FlexEvent.CREATION_COMPLETE事件，则测试完全失败。
			Async.proceedOnEvent(this, textInput, FlexEvent.CREATION_COMPLETE, 1000);
			UIImpersonator.addChild(textInput);
		}
		
		[After(async, ui)]
		public function tearDown():void {
			UIImpersonator.removeChild(textInput);
			textInput = null;
		}
		
		private static function createPassThroughData():Object{
			var passThroughData:Object = new Object();
			passThroughData.propertyName = 'text';
			passThroughData.propertyValue = 'hello';
			return passThroughData;
		}
		
		//这里采用异步的方法来断言字段textInput.text被成功赋值，是为了演示异步事件处理器的用法。
		[Test(async)]
		public function testSetTextPropertyAsynchronously() : void {
			var passThroughData:Object = createPassThroughData();
			textInput.addEventListener(
				FlexEvent.VALUE_COMMIT, 
				Async.asyncHandler(this, handleVerifyProperty, 100, passThroughData, handleEventNeverOccurred), 
				false, 
				0, 
				true);
			textInput[passThroughData.propertyName] = passThroughData.propertyValue; 
		}
		
		protected function handleVerifyProperty(event:Event, passThroughData:Object):void {
			Assert.assertEquals(event.target[passThroughData.propertyName], passThroughData.propertyValue);
		}
		
		protected function handleEventNeverOccurred(passThroughData:Object):void {
			Assert.fail('Pending Event Never Occurred');
		}
		
		//在textInput.text被赋值完毕之后，直接进行断言，亦是可行的。由此推断，此赋值过程，应该是一个同步的过程。
		[Test(async)]
		public function testSetTextPropertySynchronously():void {
			var passThroughData:Object = createPassThroughData();
			textInput[passThroughData.propertyName] = passThroughData.propertyValue;
			Assert.assertEquals(textInput[passThroughData.propertyName], passThroughData.propertyValue);
		}
	}
}