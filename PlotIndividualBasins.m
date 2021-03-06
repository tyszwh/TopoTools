function PlotIndividualBasins(location_of_data_files)
	% Function takes outputs from 'ProcessRiverBasins' function and makes and saves plots for each basin with stream profiles, chi-z, and slope area
	%
	%Inputs:
	% location_of_data_files - full path of folder which contains the mat files from 'ProcessRiverBasins'
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Function Written by Adam M. Forte - Last Revised Fall 2015 %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	cd(location_of_data_files);
	
	%% Build File List
	% Get Basin Numbers
	AllFullFiles=dir('*_Data.mat');
	num_basins=numel(AllFullFiles);
	basin_nums=zeros(num_basins,1);
	for jj=1:num_basins
		fileName=AllFullFiles(jj,1).name;
		basin_nums(jj)=sscanf(fileName,'%*6s %i'); %%%
	end

	FileCell=cell(num_basins,1);
	for kk=1:num_basins
		basin_num=basin_nums(kk);
		SearchAllString=['*_' num2str(basin_num) '_Data.mat'];
		SearchSubString=['*_' num2str(basin_num) '_DataSubset*.mat'];

		if numel(dir(SearchSubString))>0
			Files=dir(SearchSubString);
		else
			Files=dir(SearchAllString);
		end

		FileCell{kk}=Files;
	end
	fileList=vertcat(FileCell{:});
	num_files=numel(fileList);

	for ii=1:num_files
		load(fileList(ii,1).name,'DEMc','Chic','Sc','SAc','RiverMouth','drainage_area');

		f1=figure(1);
		set(f1,'Units','inches','Position',[1.0 1.5 10 10],'renderer','painters','PaperSize',[10 10],'PaperPositionMode','auto');

		clf
		subplot(3,1,1);
		hold on
		plotdz(Sc,DEMc,'dunit','km','smooth',true);
		xlabel('Distance (km)');
		ylabel('Elevation (m)');
		hold off

		subplot(3,1,2);
		hold on
		plot(Chic.chi,Chic.elev,'-k');
		xlabel('Chi');
		ylabel('Elevation (m)');
		hold off

		a1=subplot(3,1,3);
		hold on
		scatter(SAc.a,SAc.g,'o','MarkerFaceColor','b','MarkerEdgeColor','k');
		set(a1,'XScale','log','YScale','log');	
		xlabel('Log Area');
		ylabel('Log Slope');
		hold off

		suptitle(['Basin Number: ' num2str(RiverMouth(:,3)) ' - Drainage Area: ' num2str(drainage_area)]);

		fileName=['BasinPlot_' num2str(RiverMouth(:,3)) '.pdf'];
		print(f1,'-dpdf',fileName);
		close all

	end
end