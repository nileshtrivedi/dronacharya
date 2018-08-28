pragma solidity ^0.4.22;

/// @title Flight Plans Ledger
contract FlightPlansLedger {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single approver.
    struct Approver {
        uint weight; // weight determines the permission to approve
        bool approved;  // if true, that person already approved
    }

    // This is a type for a Flight Plan.
    struct FlightPlan {
        uint trip_id; // trip id for the drone
        uint drone_id; // id of the drone
        uint operator_id; // id of the operator
        bytes32 purpose;   // short purpose
        bytes32 plan; // actual plan
        address [] approvers; // addresses of approvers
        address [] disapprovers; // addresses of disapprovers
    }
    
    address public commander; // one who determines the approvers
    
    uint approversCount; // total approvers count

    // This declares a state variable that
    // stores a `Approver` struct for each possible address.
    mapping(address => Approver) public approvers;

    // A flight plan struct.
    FlightPlan public flightPlan;

    /// Create a new flight plan to be approved.
    constructor(uint trip_id, uint drone_id, uint operator_id, bytes32 purpose, bytes32 plan) public {
        commander = msg.sender;
        approvers[commander].weight = 1;
        
        flightPlan.trip_id = trip_id;
        flightPlan.drone_id = drone_id;
        flightPlan.operator_id = operator_id;
        flightPlan.purpose = purpose;
        flightPlan.plan = plan;
    }

    // Give `approver` the right to approve this flight plan.
    // May only be called by `commander`.
    function giveRightToApprove(address approver) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        require(
            msg.sender == commander,
            "Only commander can give approver a right to vote."
        );
        require(
            !approvers[approver].approved,
            "The approver already approved."
        );
        require(approvers[approver].weight == 0); // only non-permitted approvers can be permitted to approve.
        approvers[approver].weight = 1; // allow non-permitted approver to be approve.
        approversCount += 1; // total approvers count increase by 1.
    }

    /// Approve a flight plan.
    function approve(bool approveStatus) public {
        Approver storage sender = approvers[msg.sender];
        require(!sender.approved, "Already voted."); // approver already made his decision.
        sender.approved = true; // approver made his decision.
        require(
            sender.weight == 1,
            "Approver doesn't have a right to vote."
            );
        // if approved true
        if (approveStatus) {
            flightPlan.approvers.push(msg.sender); // add approver address to approvers array.
        }
        else {
            flightPlan.disapprovers.push(msg.sender); // add approver to disapprovers array.
        }
    }
    
    // get approvers address list.
    function getApprovedApprovers() public view returns (address[] approvedApprovers) {
        approvedApprovers = flightPlan.approvers;
    }
    
    // get disapprovers address list.
    function getApprovedDisapprovers() public view returns (address[] approvedDisapprovers) {
        approvedDisapprovers = flightPlan.disapprovers;
    }

    /// @dev 2Checks if flight plan is approved or not.
    function checkFlightApproval() public view
            returns (bool approveStatus)
    {
        if (flightPlan.approvers.length == approversCount) {
            approveStatus = true;
        }
        else {
            approveStatus = false;
        }
    }
}
