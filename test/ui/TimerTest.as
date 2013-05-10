package ui
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	public class TimerTest
	{
		private static const TIMEOUT_SHOULD_NOT_REACH_HERE:String = "Should not reach here. ";
		private var timer:Timer;
		
		//每个单元测试方法执行前后，都会调用setUp和tearDown方法。即为每个单元测试方法提供fixture。
		[Before]
		public function setUp():void {
			//这里的100是指方法timer.start()执行之后，经过100毫秒，触发事件TimerEvent.TIMER一下。
			//第二个参数1，表示这个timer只运行一轮。由此可知，方法timer.start()执行之后，经过100毫秒，会同时抛出
			//TimerEvent.TIMER事件和TimerEvent.TIMER_COMPLETE事件。
			timer = new Timer( 100, 1 );
		}
		
		[After]
		public function tearDown():void {
			if(timer) {
				timer.stop();
			}
			timer = null;
		}
		
		//这里先定义异步handler变量asyncHandler:Function，再把此asyncHandler加入到timer的listener列表中。
		[Test(async, description="Async Example")]
		public function testTimerLongWay():void {
			//这里的500毫秒，可以理解为timer.start()之后，如果超过500毫秒，还没有抛出TimerEvent.TIMER_COMPLETE，
			//则会跳转到handleTimeout处理器中。
			//这里的500毫秒与handleTimerComplete没有关系。
			var asyncHandler:Function = Async.asyncHandler(this, handleTimerComplete, 500, null, handleTimeout);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true);
			timer.start();
		}
		
		protected function handleTimerComplete(event:TimerEvent, passThroughData:Object):void{
			
		}
		
		protected function handleTimeout(passThroughData:Object):void {
			Assert.fail(TIMEOUT_SHOULD_NOT_REACH_HERE);
		}
		
		[Test(async, description="An async test that will fail")]
		public function testAsyncFail():void {
			//timer的delay字段被设为1000毫秒，在timer.start()之后的500毫秒后，会触发TimerEvent.TIMER_COMPLETE事件，
			//从而调用处理器handleTimerCompleteWithBigDelay。
			timer.delay = 1000;
			var asyncHandler:Function = Async.asyncHandler(this, handleTimerCompleteWithBigDelay, 500, null, handleTimeoutWithBigDelay);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true);
			timer.start();
		}
		
		protected function handleTimerCompleteWithBigDelay(event:TimerEvent, passThroughData:Object):void{
			Assert.fail(TIMEOUT_SHOULD_NOT_REACH_HERE);
		}
		
		protected function handleTimeoutWithBigDelay( passThroughData:Object ):void {
			
		}
		
		[Test(async)]
		public function timerCount() : void {
			//这里定义的passThroughData，将会被timer和接下来的handleTimerCheckCount方法使用。
			//否则就要定义一个全局变量来给这两个地方使用。
			var passThroughData:Object = new Object();
			passThroughData.repeatCount = 3;
			
			//指定这个timer执行的次数为3。
			timer.repeatCount = passThroughData.repeatCount;
			timer.addEventListener(TimerEvent.TIMER, handlerTimerEvent);
			timer.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				Async.asyncHandler(this, handleTimerCompleteEventCheckCount, 500, passThroughData, handleTimeout), 
				false, 
				0, 
				true);
			timer.start();	
		}
		
		private static var expectedCurrentCount:int = 1;
		private function handlerTimerEvent(timerEvent:TimerEvent):void{
			Assert.assertEquals(expectedCurrentCount, (timerEvent.target as Timer).currentCount);
			expectedCurrentCount++;
		}
		
		//当Timer运行完毕，会触发TimerEvent.TIMER_COMPLETE事件，这时(timerEvent.target as Timer).currentCount值应该为3，因为我之前手动地设置
		//了passThroughData.repeatCount = 3;
		protected function handleTimerCompleteEventCheckCount(timerEvent:TimerEvent, passThroughData:Object):void {
			//这里的入参passThroughData，相当于expected的值。
			Assert.assertEquals(passThroughData.repeatCount, (timerEvent.target as Timer).currentCount);
		}
	}
}