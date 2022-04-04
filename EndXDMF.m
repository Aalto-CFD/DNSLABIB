fileID = fopen('openWithParaView.xmf','a');
fprintf(fileID,'  </Grid>\n');
fprintf(fileID,' </Domain>\n');
fprintf(fileID,'</Xdmf>\n');
fclose('all');
