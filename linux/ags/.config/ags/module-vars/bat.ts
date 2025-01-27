import GLib from "gi://GLib";

type BatteryInfo = {
  capacity: number; // Battery charge percentage
  status: string;   // Charging, Discharging, Full
};

const getBatteryInfo = (): BatteryInfo => {
  const batteryPath = "/sys/class/power_supply/BAT0";
  const capacityPath = `${batteryPath}/capacity`;
  const statusPath = `${batteryPath}/status`;

  // Read capacity
  const [capacitySuccess, capacityBytes] = GLib.file_get_contents(capacityPath);
  if (!capacitySuccess) {
    console.error("Failed to read battery capacity");
    return { capacity: 0, status: "Unknown" };
  }
  const capacity = Number.parseInt(
    new TextDecoder("utf-8").decode(capacityBytes).trim(),
    10,
  );

  // Read status
  const [statusSuccess, statusBytes] = GLib.file_get_contents(statusPath);
  if (!statusSuccess) {
    console.error("Failed to read battery status");
    return { capacity, status: "Unknown" };
  }
  const status = new TextDecoder("utf-8").decode(statusBytes).trim();

  return { capacity, status };
};

// Reactive variable to update the battery information periodically
export const batteryInfo = Variable(
  { capacity: 0, status: "Unknown" },
  {
    poll: [
      2000, // Poll every 2 seconds
      () => {
        try {
          return getBatteryInfo();
        } catch (error) {
          console.error("Error polling battery information:", error);
          return { capacity: 0, status: "Unknown" };
        }
      },
    ],
  }
);
