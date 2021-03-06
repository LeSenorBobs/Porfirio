package;

import openfl.Assets;
import openfl.Lib;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.display.Tilemap;

import flash.geom.Rectangle;

/**
 * A sprite animation playing class
 * Loads a sprite sheet with a number of animation in it
 * Determines a frame rate to play the animations at
 *
 */
class Runner extends Sprite
{
	// the TileSheet instance containing the sprite sheet
	var tileSet:Tileset;

	var tilemap:Tilemap;

	// the variable determining the frame rate of the animations
	static inline var fps:Int = 6;

	// calculates the milliseconds every frame should be visible (based on fps above)
	var msPerFrame:Int = Std.int( 1000 / fps );

	// the total amount of frames in the sprite sheet (used to define all frame rectangles)
	static inline var frameCount:Int = 15;

	// time measurement to get the proper frame rate
	var currentDuration:Int = 0;
	var currentFrame = 1;

	// the arrays containing the frame numbers of the animations in the sprite sheet
	var duckSequence:Array<Int> = [0];
	var idleSequence:Array<Int> = [1, 2, 3, 4];
	var jumpSequence:Array<Int> = [5, 6, 7, 8];
	var runSequence:Array<Int> = [9, 10, 11, 12, 13, 14];

	// the current animation. one of the above sequences will be referenced by this variable.
	var currentStateFrames:Array<Int>;

	public function new()
	{
		super();

		var bitmapData:BitmapData = Assets.getBitmapData( "assets/angry runner.png" );
		tileSet = new Tileset( bitmapData );

		tilemap = new Tilemap( 32, 32, tileSet );

		initializeSpriteSheet();

		tilemap.addTile( new Tile( 1 ) );

		addChild( tilemap );

		currentStateFrames = idleSequence;
	}

	/**
	 * Loads bitmap data in the into a TileSheet instance
	 * Set the rects of the frames in the Tilesheet instance
	 * 
	 */
	private function initializeSpriteSheet()
	{
		// this sprite sheet is a single row. Easy loop...
		// accidentally it's a PoT (power of two) size (512x32 px here)
		// individual frames are 32x32 px
		for (i in 0 ... frameCount) 
		{
			tileSet.addRect( new Rectangle ( i * (32+1), 0, 32, 32 ) );
		}
	}

	public function toggleAnimation()
	{
		if( currentStateFrames == idleSequence )
		{
			currentStateFrames = runSequence;
		}
		else
		{
			currentStateFrames = idleSequence;
		}
		currentFrame = 0;
		currentDuration = 0;
	}

	/**
	 * update this sprite
	 * - Calculate the time the current frame was visible
	 * - if more than msPerFrame, show next frame of animation
	 * - loop animation if the last frame was reached
	 * 
	 * @param deltaTime 	The time passed since the last update (in seconds)
	 */
	public function update( deltaTime:Float )
	{
		currentDuration += Std.int(deltaTime * 1000);

		if( currentDuration > msPerFrame )
		{
			currentDuration -= msPerFrame;
			currentFrame++;

			if( currentFrame >= currentStateFrames.length )
				currentFrame = 0;
			
			tilemap.removeTile( tilemap.getTileAt( 0 ) );
			tilemap.addTile( new Tile( currentStateFrames[currentFrame] ) );
		}
	}
}