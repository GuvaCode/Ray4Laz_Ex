unit mUnit;

{$mode objfpc}{$H+} 

interface

uses
  cmem, ray_header, ray_application, ray_sprite_engine;

type

{ Tux }

TTux = class(TAnimatedSprite)
  public
   procedure Move(MoveCount: Double); override;
end;

TGame = class(TRayApplication)
  private
  protected
    Icon:TImage;
  public
    Tux:TTux;
    SpriteEngine: TSpriteEngine;
    GameTexture: TGameTexture;
    constructor Create; override;
    procedure Update; override;
    procedure Render; override;
    procedure Shutdown; override;
    procedure Resized; override;
  end;

implementation

{ Tux }

procedure TTux.Move(MoveCount: Double);
begin
  inherited Move(MoveCount);
  if not DoAnimate then AnimPos:=0;
  LookAt(GetMouseX,GetMouseY);
  MoveTowards(GetMousePosition,0.5);
end;

constructor TGame.Create;
begin
  //setup and initialization engine
  InitWindow(800, 600, 'raylib [Game Project]'); // Initialize window and OpenGL context 
  SetWindowState(FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT); // Set window configuration state using flags

  SetTargetFPS(60); // Set target FPS (maximum)
  ClearBackgroundColor:= BLACK; // Set background color (framebuffer clear color)
  // Greate the sprite engine and texture image list 
  SpriteEngine:=TSpriteEngine.Create;
  GameTexture:= TGameTexture.Create;

  Icon:=LoadImage('data/raylogo.png'); // Load window icon
  SetWindowIcon(Icon);

  GameTexture.LoadFromFile('data/gfx/tux_walking.png');

  Tux:=TTux.Create(SpriteEngine,GameTexture);
  Tux.X:=800/2.0 - 64/2;
  Tux.Y:=600/2.0 - 64/2;
  Tux.SetPattern(64,64);
  Tux.AngleVectorX:=64/2;
  Tux.AngleVectorY:=64/2;
  Tux.SpeedX:=0.0020;
  Tux.TextureFilter:=tfBilinear;
end;

procedure TGame.Update;
begin
  SpriteEngine.Move(GetFrameTime); // move all sprites in SpriteEngine
  if IsKeyDown(KEY_LEFT) then
  begin
    Tux.MirrorMode:=MmX;
    Tux.SetAnim(0,8,20,True);
  end;
    if IsKeyDown(KEY_RIGHT) then
  begin
    Tux.MirrorMode:=MmNormal;
    Tux.SetAnim(0,8,20,True);
  end;

   if IsKeyDown(KEY_SPACE) then
    begin
     if Tux.DoAnimate then Tux.DoAnimate:=false else Tux.DoAnimate:=true;
    end;

end;

procedure TGame.Render;
begin
  //BeginMode2D(SpriteEngine.Camera);
  SpriteEngine.Draw;
//  EndMode2D;
  DrawFPS(10, 10); // Draw current FPS
  DrawText('Press Left or Right to shange Mirror mode. Press Space to start or stop animation.',10,30,10,RED);
end;

procedure TGame.Resized;
begin
  SpriteEngine.VisibleWidth:=GetScreenWidth;
  SpriteEngine.VisibleHeight:=GetScreenHeight;
end;

procedure TGame.Shutdown;
begin
  SpriteEngine.Free;
  GameTexture.Free;
end;

end.

