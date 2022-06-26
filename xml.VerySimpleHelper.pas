{ VerySimpleXMLHelper v0.0.1 
  (c) Copyrights 2021  <it@lawa-frische.de>									
  * This Source Code Form is subject to the terms of the Mozilla Public *
  * License, v. 2.0. If a copy of the MPL was not distributed with this *
  * file, You can obtain one at https://mozilla.org/MPL/2.0/.           *
  *                                                                     *
  *   Software distributed under the License is distributed on an       *
  *   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or    *
  *   implied. See the License for the specific language governing      *
  *   rights and limitations under the License.                         *
}

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
