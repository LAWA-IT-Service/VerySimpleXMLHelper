unit xml.VerySimpleHelper;

interface

uses
  System.Classes,
  xml.VerySimple;

type

  TMyXMLNode = class helper for TXmlNode
    function HasCDataChild: Boolean;
    function GetCDataChild: TXmlNode;
    function CData: String;
  end;

  TMyXMLVerySimple = class helper for TXMlVerySimple
    procedure Normalize(IncludeParent: Boolean);
  end;

implementation

{ TMyXMLNode }

function TMyXMLNode.CData: String;
begin
  if HasChildNodes then
    if ChildNodes[0].NodeType = ntCData then
      Result := ChildNodes[0].Text
    else
      Result := '';
end;

function TMyXMLNode.GetCDataChild: TXmlNode;
begin
  if HasCDataChild then
    Result := ChildNodes[0]
  else
    Result := TXmlNode.create;
end;

function TMyXMLNode.HasCDataChild: Boolean;
begin
  Result:= false;
  if HasChildNodes then
    Result := ChildNodes[0].NodeType = ntCData;
end;

{ TMyXMLVerySimple }

procedure TMyXMLVerySimple.Normalize(IncludeParent: Boolean);
var
  TempXML: TXMlVerySimple;
  node : TXMLNode;
  procedure GetChildListe(node: TXmlNode; var Result: TXMlVerySimple;
    IncludeParent: Boolean = false);
  var
    child: TXmlNode;
  begin
    if node.HasChildNodes then
    begin
      if IncludeParent then
        with Result.ChildNodes.Add(node.name) do
          AttributeList.Assign(node.AttributeList);
      for child in node.ChildNodes do
        GetChildListe(child, Result, IncludeParent);
    end
    else
      with Result.ChildNodes.Add(node.name) do
      begin
        Text:=node.Text;
        AttributeList.Assign(node.AttributeList);
      end;
  end;

begin
  TempXML := TXMlVerySimple.create;
  TempXML.Text := Self.Text;
  self.Clear;
  for node in TempXML.DocumentElement.ChildNodes do
    GetChildListe(node, self, IncludeParent);
  TempXml.Free;
end;

end.
